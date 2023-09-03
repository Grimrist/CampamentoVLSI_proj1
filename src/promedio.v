`timescale 1ns / 1ps

module promedio #(parameter N=8)(
	input clk, 
	input reset, 
	input en,
	input sum_en,
	input [15:0] in,
	output reg [N-1:0] out,
	output reg sum_ready
); 

reg [15:0] contador;
reg [N-1:0] suma;

always @(posedge clk) begin
	if(reset | !en | !sum_en) contador <= 0;
	else contador <= contador + 1;
end

always @(posedge clk) begin
	if(reset | !sum_en | !en) suma <= 0;
	else if(contador > 3) suma <= suma;
	else suma <= suma + in;
end	

always @(posedge clk) begin
	if(reset) sum_ready <= 0;
	else if(contador == 4) sum_ready <= 1;
	else sum_ready <= 0;
end

always @(posedge clk) begin
	if(reset) out <= 0;
	else if(sum_ready) out <= suma >> 2;
end


// always @(posedge clk) begin
// 	if(reset) promedio <= 0;
// 	else if(sum_ready) begin
// 		promedio <= suma >> 2;
// 		prom_ready <= 1;
// 	end
// end 
endmodule
