`default_nettype none
`timescale 1ns / 1ps

module tt_um_grimrist_temp_sens_hyst(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to !rst_n
);

wire rx, rx_ready, tx, tx_start, tx_busy;
wire sum_ready, sum_en;
wire osc_sel, en_inv_osc, en_nand_osc, en;
wire clk_external, clk_sel, clk_in;
wire out_osc_inv, out_osc_nand, out_osc;
wire [7:0] promedio;
wire [9:0] count;
reg [7:0] count_reg;
wire [7:0] rx_data;
reg [7:0] tx_data;
wire send_sel;
wire temp_warn;
reg [7:0] temp_high;
reg [7:0] temp_low;
wire en_send;
wire en_reg1;
wire en_reg2;

//Set all bidirectional IOs to output
assign uio_oe = 8'b11111111;

//INPUTS
assign clk_external = ui_in[0];
assign clk_sel = ui_in[1];
assign en_inv_osc = ui_in[2];
assign en_nand_osc = ui_in[3];
assign rx = ui_in[4];
assign osc_sel = ui_in[5];

//OUTPUTS
assign uo_out[0] = tx;
assign uo_out[1] = temp_warn;
assign uo_out[7:2] = 0;
assign uio_out = count_reg;

//Clocks management
mux m(clk_external, clk, clk_sel, clk_in);

mux m3(en_inv_osc, en_nand_osc, osc_sel, en);

//tx_data management
always @* begin
	case(send_sel)
		0: tx_data = promedio[7:0];
		1: tx_data = 0;
	endcase
end

//Oscillators
USM_ringoscillator_inv2 osc1(en_inv_osc, out_osc_inv);
USM_ringoscillator_nand4 osc2(en_nand_osc, out_osc_nand);
mux m2(out_osc_inv, out_osc_nand, osc_sel, out_osc);

//Counters
contador #(10) cont(out_osc, en, !rst_n, clk_in, count);

always @(posedge clk_in) begin
	if(!rst_n) count_reg <= 0;
	else count_reg <= count[7:0]; 
end

promedio #(10) prom(clk_in, !rst_n, en, sum_en, count, promedio, sum_ready);

//Registers for threshold storage

always @(posedge clk_in) begin
	if(!rst_n) temp_high <= 0;
	else if (en_reg1) temp_high <= rx_data;
    else temp_high <= temp_high;
end

always @(posedge clk_in) begin
	if(!rst_n) temp_low <= 0;
	else if (en_reg2) temp_low <= rx_data;
    else temp_low <= temp_low;
end

//Controllers
FSM_Controller controller(clk_in, !rst_n, rx_data, rx_ready, en_send, en_reg1, en_reg2);
FSM_Hysteresis #(8) hysteresis(clk_in, !rst_n, temp_high, temp_low, promedio, temp_warn);
FSM_SendData sendData(clk_in, !rst_n, sum_ready, en_send, sum_en, tx_start, send_sel);


//Communication
uart_basic #(10000,1000) uart(clk_in, !rst_n, rx, rx_data, rx_ready, tx, tx_start, tx_data, tx_busy);


endmodule
