/*
***********Documentation*****************
*@file		:UART_TX_TOP		*
*@author	:Robir Tamer		*
*****************************************
*/
module UART_TX_TOP (
/****************INPUTS*****************/

input	wire		CLK,
input	wire		RST,
input	wire		transmit,
input	wire	[7:0]	TX_DATA,
input	wire		par_EN,
input	wire		TX_tick,

/****************OUTPUTS****************/
output	wire		TXD,
output	wire		busy
);
/****************SIGNALS****************/
wire		ser_data;
wire		ser_done;
wire		ser_EN;

wire		par_bit;

wire	[1:0]	MUX_SEL;
/****************INSTANTIALTION****************/
/*SERIALIZER*/
SERIALIZER B1 (
.CLK		(CLK),
.RST		(RST),
.EN		(ser_EN),
.TX_DATA	(TX_DATA),
.TX_tick	(TX_tick),

.ser_data	(ser_data),
.ser_done	(ser_done)
);
/*PARITY*/
PARITY B2 (
.CLK		(CLK)	 ,
.RST		(RST)	 ,
.EN		(par_EN) ,
.TX_DATA	(TX_DATA),
.TX_tick	(TX_tick),

.par_bit	(par_bit)
);
/*FSM*/
FSM B3 (
.CLK		(CLK)	  ,
.RST		(RST)	  ,
.transmit	(transmit),
.ser_done	(ser_done),
.par_EN		(par_EN)  ,
.TX_DATA	(TX_DATA) ,
.TX_tick	(TX_tick),

.MUX_SEL	(MUX_SEL) ,
.ser_EN		(ser_EN)  ,
.busy		(busy)	  
);
/*MUX*/
MUX B4 (
.CLK		(CLK)	  ,
.RST		(RST)     ,
.MUX_SEL	(MUX_SEL) ,
.ser_data	(ser_data),
.par_bit	(par_bit),
.TX_tick	(TX_tick),

.TX_OUT		(TXD)  
);

endmodule
