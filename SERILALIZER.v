/*
***********Documentation*****************
*@file		:SERIALIZER		*
*@author	:Robir Tamer		*
*****************************************
*/
module SERIALIZER (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		EN,
input	wire	[7:0]	TX_DATA,
input	wire		TX_tick,


/****************OUTPUTS****************/
output	reg		ser_data,
output	reg		ser_done
);
/****************SIGNALS****************/
reg	[7:0]	FFS;
reg	[2:0]	Counter;
reg		busy_flag;
/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				FFS<='b0;
				ser_done<=1'b0;
				Counter<=3'b0;
				busy_flag <=0;
			end
		else if (!busy_flag && TX_tick)
			begin
				FFS<=TX_DATA;
				ser_done<=1'b0;
				Counter<=3'b000;
				busy_flag<=1;
			end
		else if (EN && TX_tick)
			begin
				if (~&Counter)
					begin	
						ser_data<=FFS[0];
						FFS <= FFS>>1;
						Counter<=Counter + 'b1;
					end 
				else
					begin
						ser_data <= FFS[0];
						ser_done<=1'b1;
					end
			end
	end
endmodule
