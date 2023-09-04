`timescale 1ns / 1ps

module FSM_Controller (
	//INPUTS
	input clk, reset,
	input [7:0] rx_data,
	input rx_ready,
	//OUTPUTS
	output reg en_send,
	output reg en_reg1,
	output reg en_reg2
);

reg [3:0] state, next_state;
localparam IDLE = 0;
localparam DECODER = 1;
localparam ENABLE_SEND = 2;
localparam WAIT_REG1_A = 3;
localparam STORE_REG1_A = 4;
localparam WAIT_REG1_B = 5;
localparam STORE_REG1_B = 6;
localparam WAIT_REG2_A = 7;
localparam STORE_REG2_A = 8;
localparam WAIT_REG2_B = 9;
localparam STORE_REG2_B = 10;


localparam CODE_SEND = 0;
localparam CODE_REG = 1;

always @* begin
	//Default state of outputs
	next_state = state;
	en_send = 0;
	en_reg1 = 0;
	en_reg2 = 0;
	//FSM core
	case(state)
		//Default state: The cycle starts once new data is received through the UART RX.
		IDLE: begin
			if(rx_ready) next_state = DECODER;
			else next_state = state;
		end
		//State that decodes the input signal to enter either calibration mode or data sending mode.
		DECODER: begin
			if(rx_data == CODE_REG) next_state = WAIT_REG1_A;
			else if (rx_data == CODE_SEND) next_state = ENABLE_SEND;
			else next_state = state;
		end
		//State that activates the SendData state machine for perpetual data transmission.
		ENABLE_SEND: begin
			en_send = 1;
			next_state = IDLE;
		end
		//State chain to store the upper and lower threshold of the temperature warning.
		//As the UART channel is 8 bits, we must wait and store in each register twice.
		
		//First, we store the upper threshold.
		WAIT_REG1_A: begin
			if(rx_ready) next_state = STORE_REG1_A;
			else next_state = state;
		end
		STORE_REG1_A: begin
			en_reg1 = 1;
			next_state = WAIT_REG1_B;
		end
		WAIT_REG1_B: begin
			if(rx_ready) next_state = STORE_REG1_B;
			else next_state = state;
		end
		STORE_REG1_B: begin
			en_reg1 = 1;
			next_state = WAIT_REG2_A;
		end

		//Now, we store the lower threshold.
		WAIT_REG2_A: begin
			if(rx_ready) next_state = STORE_REG2_A;
			else next_state = state;
		end
		STORE_REG2_A: begin
			en_reg2 = 1;
			next_state = WAIT_REG2_B;
		end
		WAIT_REG2_B: begin
			if(rx_ready) next_state = STORE_REG2_B;
			else next_state = state;
		end
		STORE_REG2_B: begin
			en_reg2 = 1;
			next_state = IDLE;
		end
		default: begin
			next_state = IDLE;
		end

	endcase
end

//Stete control
always @(posedge clk) begin
	if(reset) state <= IDLE;
	else state <= next_state;
end

endmodule
