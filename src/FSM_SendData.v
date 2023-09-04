`timescale 1ns / 1ps

module FSM_SendData (
	//INPUTS
	input clk, reset, sum_ready, 
	input en_send,
	//OUTPUTS
	output reg sum_en,
	output reg tx_send,
	output reg send_sel
);

reg [15:0] timer;

reg [3:0] state, next_state;
localparam IDLE = 0;
localparam WAIT_SUM = 1;
localparam SEND_SUM_1 = 2;
localparam WAIT_SEND_1 = 3;
localparam SEND_SUM_2 = 4;
localparam WAIT_SEND_2 = 5;

always @* begin
	//Default state of outputs
	next_state = state;
	sum_en = 0;
	tx_send = 0;
	send_sel = 0;
	//FSM core
	case(state)
		//Default state: The cycle starts once the enable signal is received from FSM_Mode.
		IDLE: begin
			if(en_send) next_state = WAIT_SUM;
			else next_state = state;
		end
		//Wait state: starts the averager and waits for a result.
		WAIT_SUM: begin
			sum_en = 1;
			if(sum_ready) next_state = SEND_SUM_1;
			else next_state = state;
		end
		//Send state: enable the UART signal to send the sum with the UART.
		SEND_SUM_1: begin
			tx_send = 1;
			next_state = WAIT_SEND_1;
		end
		WAIT_SEND_1: begin
			if(timer >= 100) next_state = SEND_SUM_2;
		end
		SEND_SUM_2: begin
			tx_send = 1;
			send_sel = 1;
			next_state = WAIT_SEND_2;
		end
		WAIT_SEND_2: begin
			send_sel = 1;
			if(timer >= 100) next_state = WAIT_SUM;
		end
		default: begin
			next_state = IDLE;
		end
//		SEND_SUM_3: begin
//			tx_send = 1;
//			send_sel = 2;
//			next_state = WAIT_SEND_3;
//		end
//		WAIT_SEND_3: begin
//			send_sel = 2;
//			if(timer >= 100) next_state = WAIT_SUM;
//		end
	endcase
end
//Stete control
always @(posedge clk) begin
	if(reset) state <= IDLE;
	else state <= next_state;
end

always @(posedge clk) begin
	if(reset) timer <= 0;
	else if(state != next_state) timer <= 0;
	else timer <= timer + 1;
end

endmodule
