
/*
***********Documentation*****************
*@file		:MUX			*
*@author	:Robir Tamer		*
*****************************************
*/
module MUX (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire	[1:0]	MUX_SEL,
input	wire		ser_data,
input	wire		par_bit,
input	wire		TX_tick,

/****************OUTPUTS****************/
output	reg		TX_OUT
);
/****************SIGNALS****************/

/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				TX_OUT<=1'b0;
			end
		else if (TX_tick)
			begin
				case (MUX_SEL)
					2'b00 :	TX_OUT<=0;
					2'b01 : TX_OUT<=ser_data;
					2'b10 :	TX_OUT<=par_bit;
					2'b11 : TX_OUT<=1;

				endcase
			end

	end
endmodule