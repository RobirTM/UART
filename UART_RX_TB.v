/*
***********Documentation*****************
*@file		:UART_RX_TB		*
*@author	:Robir Tamer		*
*****************************************
*/
/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!THIS TEST IS FOR RX WITH OUT BAUD_RATE!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
/****************TIME_SCALE****************/
`timescale	1us/1us
module UART_RX_TB ();
/****************TB_SIGNALS****************/
reg		CLK_TB;
reg		RST_TB;
reg		RXD_TB;
reg		PARITY_EN_TB;

wire	[7:0]	RXDATA_TB;
wire		VALID_RX_TB;
wire		PARITY_ERROR_TB;
wire		STOP_ERROR_TB;

/****************INSTANTIATION****************/
UART_RX_TOP DUT (
.CLK		(CLK_TB),
.RST		(RST_TB),
.RXD		(RXD_TB),
.PARITY_EN	(PARITY_EN_TB),

.RXDATA		(RXDATA_TB),
.VALID_RX	(VALID_RX_TB),
.PARITY_ERROR	(PARITY_ERROR_TB),
.STOP_ERROR	(STOP_ERROR_TB)
);
/**************CLOCK_GENERATION**************/
always #5	CLK_TB=~CLK_TB;

/***************INITIAL_BLOCKS***************/
initial
	begin
		$dumpfile("UART_RX_TOP.vcd");
		$dumpvars ;
		/*initialization*/
		CLK_TB=0;
		RXD_TB=1;
		PARITY_EN_TB=1;
		RST_TB=0;
		#10
		RST_TB=1;
	
		read_check_data(8'b0110_1111,11'b10_0110_1111_0 ,1,1,0,0,1);
		read_check_data(8'b1100_1100,11'b10_1100_1100_0 ,1,1,0,0,2);
		read_check_data(8'b0011_1101,11'b11_0011_1101_0 ,1,1,0,0,3);
		read_check_data(8'b1001_0111,11'b11_1001_0111_0 ,1,1,0,0,4);
		read_check_data(8'b0101_1000,11'b11_0101_1000_0 ,1,1,0,0,5);
		read_check_data(8'b1110_0010,11'b11_1110_0010_0 ,0,1,0,0,6);
		read_check_data(8'b0001_0011,11'b11_0001_0011_0 ,0,1,0,0,7);
		read_check_data(8'b1010_1010,11'b11_1010_1010_0 ,0,1,0,0,8);
		read_check_data(8'b0111_1100,11'b11_0111_1100_0 ,0,1,0,0,9);
		read_check_data(8'b0110_1111,11'b11_0110_1111_0 ,0,1,0,0,10);
		

		read_check_data(8'b0110_1111,11'b11_0110_1111_0 ,1,0,1,0,11);
		read_check_data(8'b1100_1100,11'b00_1100_1100_0 ,1,0,0,1,12);
		read_check_data(8'b0011_1101,11'b00_0011_1101_0 ,1,0,1,1,13);
	end


/********************TASKS********************/
task read_check_data ;
input	reg	[7:0]	EX_OUT	 ;
input	reg	[10:0]	data	 ;
input	reg		parity_en;
input	reg		VALID_RX ;
input	reg		PARITY_ERROR ;
input	reg		STOP_ERROR ;
input 	integer		k	 ;
integer 		i 	 ;
	begin
		#10;
		RST_TB=0;
		#10
		RST_TB=1;
		PARITY_EN_TB = parity_en;
		#10;
		for (i=0; i<11; i=i+1)
			begin
				RXD_TB=data[i];
				#10;
			end
		#10
		$display ("OUT: %b, VALID_RX: %b, PARITY_ERROR: %b, STOP_ERROR: %b",RXDATA_TB, VALID_RX_TB, PARITY_ERROR_TB, STOP_ERROR_TB);
		$display ("OUT: %b, VALID_RX: %b, PARITY_ERROR: %b, STOP_ERROR: %b",EX_OUT, VALID_RX, PARITY_ERROR, STOP_ERROR);
		if((EX_OUT == RXDATA_TB) && (VALID_RX == VALID_RX_TB) && (PARITY_ERROR_TB == PARITY_ERROR) && (STOP_ERROR_TB == STOP_ERROR) )
			begin
				$display ("Test: %0d Passed",k);
			end
		else
			begin
				$display ("Test: %0d Failed",k);
			end
	end
endtask



endmodule
