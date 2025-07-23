/*
***********Documentation*****************
*@file		:BAUD_GENERATOR		*
*@author	:Robir Tamer		*
*****************************************
*/
module BAUD_GENERATOR #(
/************PARAMETERS************/
parameter	CLK_FREQ	= 50_000_000 ,	// 50 MHz
parameter	BAUD_RATE	= 9600
)(
/************INPUTS************/
input	wire		clk,
input	wire		rst,
/************OUTPUTS***********/
output	reg		RX_tick,
output	reg		TX_tick
);

/****************LOCAL_PARAMS****************/
localparam	TX_DIV	= CLK_FREQ / BAUD_RATE;
localparam	RX_DIV	= CLK_FREQ / (BAUD_RATE * 16);

/****************SIGNALS****************/
reg	[15:0]	tx_count;
reg	[15:0]	rx_count;

/************SEQUENTIAL_ALWAYS_BLOCK************/
always @ (posedge clk or negedge rst)
	begin
		if (!rst)
			begin
				tx_count	<= 0;
				rx_count	<= 0;
				TX_tick		<= 0;
				RX_tick		<= 0;
			end
		else
			begin
				/**********TX Tick Generation**********/
				if (tx_count == TX_DIV - 1)
					begin
						tx_count	<= 0;
						TX_tick		<= 1'b1;
					end
				else
					begin
						tx_count	<= tx_count + 1;
						TX_tick		<= 1'b0;
					end

				/**********RX Tick Generation**********/
				if (rx_count == RX_DIV - 1)
					begin
						rx_count	<= 0;
						RX_tick		<= 1'b1;
					end
				else
					begin
						rx_count	<= rx_count + 1;
						RX_tick		<= 1'b0;
					end
			end
	end

endmodule
