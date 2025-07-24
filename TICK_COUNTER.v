
/*
***********Documentation*****************
*@file		:TICK_COUNTER		*
*@author	:Robir Tamer		*
*****************************************
*/
module TICK_COUNTER (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		RX_tick,
input	wire		TICK_COUNT_EN,

/****************OUTPUTS****************/
output	reg		TICK_EN
);
/****************SIGNALS****************/
reg	[3:0]	Counter;
/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				TICK_EN<=0; 
				Counter<=4'b0;
			end
		else if (RX_tick && TICK_COUNT_EN)
			begin
				if (Counter == 4'd7)
					begin
						TICK_EN <= 1;
					end
				else if (Counter == 4'd15)
					begin
						Counter<=4'b0;
						TICK_EN<=0; 
					end
				else 
					begin
						TICK_EN<=0; 
					end
				Counter <= Counter+1;
			end

	end

endmodule