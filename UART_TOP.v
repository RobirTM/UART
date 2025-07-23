/*
***********Documentation*****************
*@file          :UART_TOP             *
*@author        :Robir Tamer          *
*****************************************
*/
module UART_TOP (
/****************INPUTS*****************/
input   wire        CLK,
input   wire        RST,
input   wire        transmit,
input   wire [7:0]  TX_DATA,
input   wire        par_EN,

/****************OUTPUTS****************/
output  wire        busy,
output  wire [7:0]  RXDATA,
output  wire        VALID_RX,
output  wire        PARITY_ERROR,
output  wire        STOP_ERROR
);

/****************SIGNALS****************/
wire            ser_bus;
wire            TX_tick;
wire            RX_tick;

/************INSTANTIATIONS************/
UART_TX_TOP TX_MODULE (
    .CLK        (CLK),
    .RST        (RST),
    .transmit   (transmit),
    .TX_DATA    (TX_DATA),
    .par_EN     (par_EN),
    .TX_tick    (TX_tick),

    .TXD        (ser_bus),
    .busy       (busy)
);

UART_RX_TOP RX_MODULE (
    .CLK        (CLK),
    .RST        (RST),
    .RXD        (ser_bus),
    .PARITY_EN  (par_EN),
    .RX_tick    (RX_tick),

    .RXDATA         (RXDATA),
    .VALID_RX       (VALID_RX),
    .PARITY_ERROR   (PARITY_ERROR),
    .STOP_ERROR     (STOP_ERROR)
);

BAUD_GENERATOR #(.CLK_FREQ(50_000_000), .BAUD_RATE(9600)) BAUD (
    .clk        (CLK),
    .rst        (RST),

    .RX_tick    (RX_tick),
    .TX_tick    (TX_tick)
);

endmodule
