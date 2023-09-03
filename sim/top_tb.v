`timescale 1ns / 1ps

module top_tb();

    reg clk_sel, clk, clk_external, en, reset, rx, osc_sel;
    wire tx;
    reg en_inv_osc, en_nand_osc;
    wire [7:0] ui_in, uo_out, uio_in, uio_out, uio_oe;
    reg rst_n, ena;
    
    assign ui_in[0] = clk_external;
    assign ui_in[1] = clk_sel;
	assign ui_in[2] = en_inv_osc;
	assign ui_in[3] = en_nand_osc;
    assign ui_in[4] = reset;
    assign ui_in[5] = rx;
    assign ui_in[6] = osc_sel;
    assign ui_in[7] = 'b0;
    assign tx = uo_out[0];
    assign temp_warn = uo_out[1];
    
    tt_um_temp_sens_hyst DUT(ui_in, uo_out, uio_in, uio_out, uio_oe, ena, clk, rst_n);
    
    //50000
    always #50000 clk = ~clk;
    always #1000 clk_external = ~clk_external;
    
    initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,top_tb);
    reset = 1;
    clk = 0;
    clk_external = 0;
    clk_sel = 1;
    osc_sel = 0;
    en_inv_osc = 0;
    en_nand_osc = 0;
    rx = 1;
    #100000 en_inv_osc = 1;
    #15000 reset = 0;
    #52083;
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 1; //bit 1
    #1000000 rx = 0; //bit 2
    #1000000 rx = 0; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 0; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    
    /* #100000000 clk_sel = 1; 
    osc_sel = 1;
    #100000000 
    en_inv_osc = 0;
    en_nand_osc = 1;
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 1; //bit 1
    #1000000 rx = 0; //bit 2
    #1000000 rx = 0; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 0; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    */
    #10000000 
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 0; //bit 1
    #1000000 rx = 1; //bit 2
    #1000000 rx = 1; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 0; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    #10000000 
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 1; //bit 1
    #1000000 rx = 1; //bit 2
    #1000000 rx = 0; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 1; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    #10000000 
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 0; //bit 1
    #1000000 rx = 0; //bit 2
    #1000000 rx = 1; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 1; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    #10000000 
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 0; //bit 1
    #1000000 rx = 0; //bit 2
    #1000000 rx = 1; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 1; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    #10000000 
    #1000000 rx = 0; //bit de inicio
    #1000000 rx = 0; //bit 1
    #1000000 rx = 0; //bit 2
    #1000000 rx = 0; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 0; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    #1000000 osc_sel = 0;
    #100000000 
    $finish; 
    end
    
endmodule