/*
***********Documentation*****************
*@file		:PARITY_CHECK		*
*@author	:Robir Tamer		*
*****************************************
*/
module PARITY_CHECK (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		EN,
input	wire	[7:0]	DATA,
input	wire		SER_DATA,
input	wire		ASS_EN,
input	wire		STOP_EN,
input	wire		RX_tick,
input	wire		TICK_EN,

/****************OUTPUTS****************/
output	reg		PARITY_ERROR,
output 	reg		STOP_ERROR
);

/****************SEQUENTIAL_ALWAYS_BLOCK****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				PARITY_ERROR <= 1'b0;
				STOP_ERROR   <= 1'b0;
			end
		else if (TICK_EN &&RX_tick)
			begin
				if (ASS_EN)
					begin
						if (EN)
							PARITY_ERROR <= (SER_DATA != ^DATA);
						else
							PARITY_ERROR <= (SER_DATA != 1'b1);
					end

				if (STOP_EN)
					begin
						STOP_ERROR <= ~SER_DATA;
					end
			end
	end

endmodule
