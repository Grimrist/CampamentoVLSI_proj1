`default_nettype none
`timescale 1ns/1ps
`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"

module nand_with_delay(
	input A, 
	output Y
);

`ifdef COCOTB_SIM
//assign #0.02 Y=~A;
assign #200 Y=~A;
`else
sky130_fd_sc_hd__nand4_4 nand4(.Y(Y), .A(A), .B(A), .C(A), .D(A));
//nand #(1) (Y,A,A);
`endif
endmodule

module inv_with_delay(
	input A, 
	output Y
);

`ifdef COCOTB_SIM
//assign #0.02 Y=~A;
assign #200 Y=~A;
`else
sky130_fd_sc_hd__inv_2 inv(.A(A),.Y(Y));
//nor #(1) (Y,A,A);
`endif
endmodule

module USM_ringoscillator_inv2(

	input en,
	output out

);


localparam etapas = 99;

wire aux_wire [etapas:0];
    
genvar i;
generate
for(i=0; i<etapas; i=i+1) begin
   inv_with_delay inv(aux_wire[i], aux_wire[i+1]);
end
endgenerate

//assign aux_wire[0] = out & en;
and andd(aux_wire[0], out, en);
assign out = aux_wire[etapas];

endmodule

module USM_ringoscillator_nand4(

	input en,
	output out

);


localparam etapas = 33;

wire aux_wire [etapas:0];
    
genvar i;
generate
for(i=0; i<etapas; i=i+1) begin
   nand_with_delay inv(aux_wire[i], aux_wire[i+1]);
end
endgenerate

//assign aux_wire[0] = out & en;
and andd(aux_wire[0], out, en);
assign out = aux_wire[etapas];

endmodule
