`timescale 1ns / 1ps

module FSM_Hysteresis #(parameter N=8) (
	//INPUTS
	input clk, reset,
    input [N-1:0] temp_high,
    input [N-1:0] temp_low,
    input [N-1:0] temp_average,
	//OUTPUTS
	output reg temp_warn
);

reg state, next_state;
localparam IDLE = 0;
localparam WARN = 1;

always @* begin
	//Default state of outputs
	next_state = state;
	temp_warn = 0;
	//FSM core
	case(state)
		//Idling state until temperature is higher than temp_high
		IDLE: begin
			if(temp_average > temp_high) next_state = WARN;
			else next_state = state;
		end
		//Send high signal through temp_warn until temperature is under temp_low
		WARN: begin
            temp_warn = 1;
			if(temp_average < temp_low) next_state = IDLE;
			else next_state = state;
		end
	endcase
end

//Stete control
always @(posedge clk) begin
	if(reset) state <= IDLE;
	else state <= next_state;
end

endmodule
