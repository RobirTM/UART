/*
***********Documentation*****************
*@file		:RX_FSM			*
*@author	:Robir Tamer		*
*****************************************
*/
module RX_FSM (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		SER_DATA,
input	wire		PARALLELISER_DONE,
input	wire		PARITY_ERROR,
input	wire		STOP_ERROR,
input	wire		RX_tick,

/****************OUTPUTS****************/
output	reg		PARALLELISER_EN,
output	reg		PAR_ASS_EN,
output	reg		STOP_EN,
output	wire		VALID_RX,
output	reg		TICK_COUNT_EN
);

/****************LOCAL_PARAMETERS****************/
localparam	[2:0]	IDLE  	= 3'b000 ,
			DATA  	= 3'b001 ,
			PARITY	= 3'b010 ,
			STOP	= 3'b100 ;

/****************SIGNALS****************/
reg	[2:0]	current_state, next_state;
reg	[3:0]	TICK_COUNT;
/********************ASSIGN_STATEMENTS********************/
assign VALID_RX	= (!STOP_ERROR && !PARITY_ERROR)? 1:0;

/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				current_state <= IDLE;
			end
		else if (RX_tick && TICK_COUNT == 4'b1111)
			begin
				current_state <= next_state;
			end
	end
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				TICK_COUNT <=0;
				TICK_COUNT_EN<=0;
			end
		else if (RX_tick && TICK_COUNT_EN)
			begin
			if (TICK_COUNT == 4'b1111)
				begin
					TICK_COUNT <=0;
				end
			else
				begin
					TICK_COUNT <= TICK_COUNT + 1;
				end
			end
	end
/****************COMBINATIONAL_ALWAYS_BLOCKS****************/
always @ (*)
	begin
		PARALLELISER_EN = 1'b0;
		PAR_ASS_EN      = 1'b0;
		STOP_EN         = 1'b0;

		case (current_state)
			IDLE   : begin
				if (!SER_DATA)
					begin
						next_state = DATA;
						TICK_COUNT_EN=1;
					end
				else
					next_state = IDLE;
			end

			DATA   : begin
				PARALLELISER_EN = 1'b1;

				if (PARALLELISER_DONE)
					begin
						next_state = PARITY;
						
					end
				else
					next_state = DATA;
			end

			PARITY : begin
				PAR_ASS_EN = 1'b1;
				PARALLELISER_EN = 1'b0;
				if (PARITY_ERROR)
					next_state = IDLE;
				else
					next_state = STOP;
			end

			STOP   : begin
				STOP_EN = 1'b1;
				next_state = IDLE;
			end

			default : begin
				PARALLELISER_EN = 1'b0;
				PAR_ASS_EN      = 1'b0;
				STOP_EN         = 1'b0;
				next_state      = IDLE;
			end
		endcase
	end
endmodule

