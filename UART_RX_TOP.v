/*
***********Documentation*****************
*@file		:UART_RX_TOP		*
*@author	:Robir Tamer		*
*****************************************
*/
module UART_RX_TOP (
/****************INPUTS*****************/

input	wire		CLK,
input	wire		RST,
input	wire		RXD,
input	wire		PARITY_EN,
input	wire		RX_tick,

/****************OUTPUTS****************/
output	wire	[7:0]	RXDATA,
output	wire		VALID_RX,
output	wire		PARITY_ERROR,
output	wire		STOP_ERROR
);
/****************SIGNALS****************/
wire			PARALLELISER_EN;
wire			PARALLELISER_DONE;
wire			PAR_ASS_EN;
wire			STOP_EN;
/****************INSTANTIALTION****************/
/*PARALLELISER*/
PARALLELISER B1 (
.CLK		(CLK),
.RST		(RST),
.EN		(PARALLELISER_EN),
.SER_DATA	(RXD),
.RX_tick	(RX_tick),

.PARALLELISER_DONE	(PARALLELISER_DONE),
.PARALLEL_DATA		(RXDATA)
);
/*PARITY_CHECK*/
PARITY_CHECK B2 (
.CLK		(CLK)	 ,
.RST		(RST)	 ,
.EN		(PARITY_EN),
.DATA		(RXDATA),
.SER_DATA	(RXD),
.ASS_EN		(PAR_ASS_EN),
.STOP_EN	(STOP_EN),
.RX_tick	(RX_tick),

.PARITY_ERROR	(PARITY_ERROR),
.STOP_ERROR	(STOP_ERROR)
);
/*RX_FSM*/
RX_FSM B3 (
.CLK			(CLK)	  ,
.RST			(RST)	  ,
.SER_DATA		(RXD),
.PARALLELISER_DONE	(PARALLELISER_DONE)  ,
.PARITY_ERROR		(PARITY_ERROR) ,
.STOP_ERROR		(STOP_ERROR)  ,
.RX_tick		(RX_tick),

.PAR_ASS_EN		(PAR_ASS_EN),
.PARALLELISER_EN	(PARALLELISER_EN) ,
.STOP_EN		(STOP_EN)  ,
.VALID_RX		(VALID_RX)	  
);

endmodule
