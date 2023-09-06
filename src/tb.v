`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    reg clk_sel, clk, clk_external, en, reset, rx, osc_sel;
    wire tx, temp_warn;
    reg en_inv_osc, en_nand_osc;
    wire [7:0] ui_in, uo_out, uio_in, uio_out, uio_oe;
    reg rst_n, ena;
    wire [7:0] count_out;

    assign ui_in[0] = clk_external;
    assign ui_in[1] = clk_sel;
    assign ui_in[2] = en_inv_osc;
    assign ui_in[3] = en_nand_osc;
    assign ui_in[4] = rx;
    assign ui_in[5] = osc_sel;
    assign ui_in[6] = sum_en_maint;
    assign ui_in[7] = sum_sel_maint;
    assign tx = uo_out[0];
    assign temp_warn = uo_out[1];
    assign count_out = uio_out;

    tt_um_USM_temp_sens_hyst tt_um_USM_temp_sens_hyst (
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        .uio_in     (uio_in),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );
endmodule
