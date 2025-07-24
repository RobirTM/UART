/*
***********Documentation*****************
*@file      :UART_TB
*@author    :Robir Tamer
*****************************************
*/
/****************TIME_SCALE****************/
`timescale 1ns/1ns

module UART_TB ();

/****************TB_SIGNALS****************/
reg         CLK_TB;
reg         RST_TB;
reg [7:0]   TX_DATA_TB;
reg         transmit_TB;
reg         par_EN_TB;

wire [7:0]  RXDATA_TB;
wire        VALID_RX_TB;
wire        PARITY_ERROR_TB;
wire        STOP_ERROR_TB;
wire        busy_TB;

/****************PARAMETERS****************/
parameter	DELAY = 12*5208*20;
/****************INSTANTIATION****************/
UART_TOP DUT (
    .CLK        (CLK_TB),
    .RST        (RST_TB),
    .transmit   (transmit_TB),
    .TX_DATA    (TX_DATA_TB),
    .par_EN     (par_EN_TB),

    .busy           (busy_TB),
    .RXDATA         (RXDATA_TB),
    .VALID_RX       (VALID_RX_TB),
    .PARITY_ERROR   (PARITY_ERROR_TB),
    .STOP_ERROR     (STOP_ERROR_TB)
);

/**************CLOCK_GENERATION**************/
always #10 CLK_TB = ~CLK_TB;  // 20ns period = 50MHz

/***************INITIAL_BLOCKS***************/
initial 
	begin
    		$dumpfile("UART_TOP.vcd");
    		$dumpvars;
	
    		CLK_TB = 0;
    		RST_TB = 0;
    		transmit_TB = 0;
    		TX_DATA_TB = 8'b0;
    		par_EN_TB = 0;
	
    		#100 RST_TB = 1;
	
    		// Send some test patterns
		read_check_data(8'b10101010, 1, 1); // Even parity ? should pass
		read_check_data(8'b11110000, 1, 2); // Odd parity ? should cause parity error
		read_check_data(8'b00001111, 0, 3); // No parity ? normal case
		read_check_data(8'b11111111, 0, 4); // No parity ? edge case all 1s
		read_check_data(8'b00000000, 0, 5); // No parity ? edge case all 0s
		read_check_data(8'b01010101, 1, 6); // Alternating bits ? check serialization
		read_check_data(8'b00111100, 1, 7); // Mixed pattern ? center 1s
		read_check_data(8'b00000001, 1, 8); // LSB only set ? check shift direction
		read_check_data(8'b10000000, 1, 9); // MSB only set ? check shift direction
   		read_check_data(8'b1111_0111, 1, 10); //Random


  		#5000
   		$stop;
end

initial begin
    $monitor("Time: %0t, RX_OUT: %b, valid: %b", $time, RXDATA_TB, VALID_RX_TB);
end

/********************TASKS********************/
task read_check_data;
    input   [7:0]   data;
    input           parity_en;
    input   integer k;
    begin
	RST_TB = 0;
	#20
	RST_TB = 1;
        par_EN_TB = parity_en;
        TX_DATA_TB = data;
        transmit_TB = 1'b1;
        #DELAY
	transmit_TB = 1'b0;
	#20

        $display("\n--- Test %0d ---", k);
        $display("TIME: %0t, OUT: %b, VALID_RX: %b, PARITY_ERROR: %b, STOP_ERROR: %b",$time ,RXDATA_TB, VALID_RX_TB, PARITY_ERROR_TB, STOP_ERROR_TB);
        $display("EXPECTED_OUT: %b", data);

        if (RXDATA_TB == data && VALID_RX_TB && !PARITY_ERROR_TB && !STOP_ERROR_TB)
            $display("Test: %0d Passed ", k);
        else
            $display("Test: %0d Failed ", k);
    end
endtask

endmodule

