/*
***********Documentation*****************
*@file		:PARITY			*
*@author	:Robir Tamer		*
*****************************************
*/
module PARITY (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		EN,
input	wire	[7:0]	TX_DATA,
input	wire		TX_tick,

/****************OUTPUTS****************/
output	reg		par_bit
);
/****************SIGNALS****************/
reg	[7:0]	Data;
/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin


		if (!RST)
			begin
				par_bit<=1; // identical to stop bit
			end
		else if (EN && TX_tick)
			begin
				par_bit<= ^Data;
			end
		else if (TX_tick) 
			begin
				par_bit<= 1;
			end
	end

always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				Data<=8'b0;
			end
		else if (TX_tick)
			begin
				Data<=TX_DATA;
			end

	end
endmodule