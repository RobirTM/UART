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
initial begin
    $dumpfile("UART_TOP.vcd");
    $dumpvars;

    CLK_TB = 0;
    RST_TB = 0;
    transmit_TB = 0;
    TX_DATA_TB = 8'b0;
    par_EN_TB = 0;

    #100 RST_TB = 1;

    // Send some test patterns
    read_check_data(8'b01101111, 1, 1);  // 'o'
    read_check_data(8'b11001100, 1, 2);
    read_check_data(8'b10101010, 1, 3);
    read_check_data(8'b00001111, 1, 4);
end

initial begin
    $monitor("Time: %0t, RX_OUT: %b", $time, RXDATA_TB);
end

/********************TASKS********************/
task read_check_data;
    input   [7:0]   data;
    input           parity_en;
    input   integer k;
    begin
        par_EN_TB = parity_en;
        TX_DATA_TB = data;
        transmit_TB = 1'b1;
        #20 transmit_TB = 1'b0;

        // total frame = 11 bits × 320ns = 3520ns ? add margin
        #4000;

        $display("\n--- Test %0d ---", k);
        $display("OUT: %b, VALID_RX: %b, PARITY_ERROR: %b, STOP_ERROR: %b", RXDATA_TB, VALID_RX_TB, PARITY_ERROR_TB, STOP_ERROR_TB);
        $display("EXPECTED_OUT: %b", data);

        if (RXDATA_TB == data && VALID_RX_TB && !PARITY_ERROR_TB && !STOP_ERROR_TB)
            $display("Test: %0d Passed ?", k);
        else
            $display("Test: %0d Failed ?", k);
    end
endtask

endmodule

