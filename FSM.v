/*
***********Documentation*****************
*@file		:FSM			*
*@author	:Robir Tamer		*
*****************************************
*/
module FSM (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		transmit,
input	wire		ser_done,
input	wire		par_EN,
input	wire	[7:0]	TX_DATA,
input			TX_tick,

/****************OUTPUTS****************/
output	reg	[1:0]	MUX_SEL,
output	reg		ser_EN,
output 	reg		busy

);
/****************LOCAL_PARAMETERS****************/
localparam	[3:0]	IDLE  	= 4'b0000 ,
			START 	= 4'b0001 ,
			DATA  	= 4'b0010 ,
			PARITY	= 4'b0100 ,
			STOP	= 4'b1000 ;
/****************SIGNALS****************/
reg	[3:0]	current_state, next_state;

/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				current_state<= IDLE;
			end
		else 
			begin
				current_state<= next_state;
			end
	end

/****************COMBINATIONAL_ALWAYS_BLOCKS****************/
always @ (*)
	begin
		if (TX_tick)
			begin
				MUX_SEL	=2'b11	;
				ser_EN 	=1'b0	;
				busy	=1'b0	;
		
				case (current_state)
					IDLE  	:	begin
								MUX_SEL=2'b11;
								if (transmit)
									begin
										next_state = START;
									end
								else
									begin
										next_state = IDLE;
									end
								end
					START 	:	begin
								MUX_SEL	= 2'b00	 ;
								ser_EN 	= 1'b1	 ;
								busy   	= 1'b1	 ;
								next_state = DATA;
							end
					DATA  	:	begin
								MUX_SEL	= 2'b01	 ;
								ser_EN 	= 1'b1	 ;
								busy   	= 1'b1	 ;
								if (ser_done)
									begin
										next_state = PARITY;
									end
								else
									begin
										next_state = DATA;
									end
							end
					PARITY	:	begin
								MUX_SEL	= 2'b10	 ;
								busy   	= 1'b1	 ;
								next_state = STOP;
							end
					STOP	:	begin
								MUX_SEL	= 2'b11	 ;
								busy   	= 1'b0	 ;
								next_state = IDLE;
							end
					default	:	begin
								MUX_SEL	=2'b11	 ;
								ser_EN 	=1'b0	 ;
								busy	=1'b0	 ;
								next_state = IDLE;
							end
					endcase
				end
		end
endmodule
	