`default_nettype none
`timescale 1ns/100ps

module promtb();

reg clk;
reg reset;
reg en;
reg sum_en;
reg [15:0] in;
wire [15:0] out; //salida
wire sum_ready; //salida

promedio #(.N(16)) prom_tb (
    .clk(clk), 
	.reset(reset),
	.en(en),
	.sum_en(sum_en),
	.in(in),
	.out(out),
	.sum_ready(sum_ready)
);

always #5 clk = ~clk;

initial begin
    $dumpfile ("promtb.vcd");
    $dumpvars (0, promtb);
    clk = 0;
    reset = 1;
    en = 0;
    sum_en = 0;
    in = 0;
    #1;
    #10;
    en = 1;
    sum_en = 1;
    reset = 0;
    in = 16'd100;
    #10;
    in = 16'd200;
    #10;
    in = 16'd300;
    #10;
    in = 16'd400;
    #30;
    sum_en = 0;
    #10
    sum_en = 1;
    in = 16'd100;
    #10;
    in = 16'd200;
    #10;
    in = 16'd300;
    #10;
    in = 16'd400;
    #30;
    sum_en = 0;
    #10
    sum_en = 1;
    in = 16'd250;
    #10;
    in = 16'd260;
    #10;
    in = 16'd240;
    #10;
    in = 16'd270;
    #50;
    $finish;
end

endmodule