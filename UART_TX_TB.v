/*
***********Documentation*****************
*@file		:UART_TX_TB		*
*@author	:Robir Tamer		*
*****************************************
*/
/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!THIS TEST IS FOR TX WITH OUT BAUD_RATE!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
/****************TIME_SCALE****************/
`timescale	1us/1us
module UART_TX_TB ();
/****************TB_SIGNALS****************/
reg		CLK_TB;
reg		RST_TB;
reg		transmit_TB;
reg	[7:0]	TX_DATA_TB;
reg		par_EN_TB;

wire		TXD_TB;
wire		busy_TB;

/****************INSTANTIATION****************/
UART_TX_TOP DUT (
.CLK		(CLK_TB),
.RST		(RST_TB),
.transmit	(transmit_TB),
.TX_DATA	(TX_DATA_TB),
.par_EN		(par_EN_TB),
.TXD		(TXD_TB),
.busy		(busy_TB)
);

/**************CLOCK_GENERATION**************/
always #5	CLK_TB=~CLK_TB;

/***************INITIAL_BLOCKS***************/
initial
	begin
		$dumpfile("UART_TX_TOP.vcd");
		$dumpvars ;
		/*initialization*/
		CLK_TB=0;
		transmit_TB=0;
		TX_DATA_TB=8'b0110_1010;
		par_EN_TB=1;
		RST_TB=0;
		#10
		RST_TB=1;
	
		read_check_data(8'b0110_1111,11'b10_0110_1111_0 ,1,1);
		read_check_data(8'b1100_1100,11'b10_1100_1100_0 ,1,2);
		read_check_data(8'b0011_1101,11'b11_0011_1101_0 ,1,3);
		read_check_data(8'b1001_0111,11'b11_1001_0111_0 ,1,4);
		read_check_data(8'b0101_1000,11'b11_0101_1000_0 ,1,5);
		read_check_data(8'b1110_0010,11'b11_1110_0010_0 ,0,6);
		read_check_data(8'b0001_0011,11'b11_0001_0011_0 ,0,7);
		read_check_data(8'b1010_1010,11'b11_1010_1010_0 ,0,8);
		read_check_data(8'b0111_1100,11'b11_0111_1100_0 ,0,9);
		read_check_data(8'b0110_1111,11'b11_0110_1111_0 ,0,10);
	end

/********************TASKS********************/
task read_check_data ;
input	reg	[7:0]	data	 ;
input	reg	[10:0]	EX_OUT	 ;
input	reg		parity_en;
input 	integer		k	 ;
reg		[10:0]	OUT	 ;
integer 		i 	 ;
	begin
		#10
		RST_TB=0;
		#10
		RST_TB=1;
		TX_DATA_TB=data;
		transmit_TB=1'b1;
		par_EN_TB = parity_en;
		#10
		for (i=0; i<11; i=i+1)
			begin
				#10
				OUT[i]=TXD_TB;
			end
		$display ("OUT: %b",OUT);
		if(EX_OUT == OUT)
			begin
				$display ("Test: %0d Passed",k);
			end
		else
			begin
				$display ("Test: %0d Failed",k);
			end
		transmit_TB=1'b0;
	end
endtask

endmodule


