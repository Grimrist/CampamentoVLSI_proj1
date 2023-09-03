`timescale 1ns / 1ps

module tb_tt03(

    );
    reg clk_sel, clk_internal, clk_external, en, reset, rx, osc_sel;
    wire tx;
    reg en_inv_osc, en_nand_osc;
    wire [7:0] io_in, io_out;
    
    assign io_in[0] = clk_internal;
    assign io_in[1] = clk_external;
    assign io_in[2] = clk_sel;
	assign io_in[3] = en_inv_osc;
	assign io_in[4] = en_nand_osc;
    assign io_in[5] = reset;
    assign io_in[6] = rx;
    assign io_in[7] = osc_sel;
    assign tx = io_out[0];
    
    top_tt03 DUT(io_in, io_out);
    
    //50000
    always #50000 clk_internal = ~clk_internal;
    always #1000 clk_external = ~clk_external;
    
    initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_tt03);
    reset = 1;
    clk_internal = 0;
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
    #1000000 rx = 0; //bit 1
    #1000000 rx = 0; //bit 2
    #1000000 rx = 0; //bit 3
    #1000000 rx = 0; //bit 4
    #1000000 rx = 0; //bit 5
    #1000000 rx = 0; //bit 6
    #1000000 rx = 0; //bit 7
    #1000000 rx = 0; //bit 8
    #1000000 rx = 1; //bit de termino
    #100000000 clk_sel = 1; 
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
    #100000000 
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
    #100000000 $finish; 
    end
    
endmodule
