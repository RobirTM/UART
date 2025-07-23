/*
***********Documentation*****************
*@file     :PARALLELISER
*@author   :Robir Tamer
*****************************************
*/
module PARALLELISER (
    /****************INPUTS****************/
    input  wire       CLK,
    input  wire       RST,
    input  wire       SER_DATA,
    input  wire       EN,
    input  wire       RX_tick,

    /****************OUTPUTS****************/
    output reg        PARALLELISER_DONE,
    output reg [7:0]  PARALLEL_DATA
);

    /****************SIGNALS****************/
    reg [3:0] tick_counter;
    reg [2:0] bit_index;
    reg       active;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            tick_counter      <= 0;
            bit_index         <= 0;
            PARALLELISER_DONE <= 0;
            PARALLEL_DATA     <= 0;
            active            <= 0;
        end
        else begin
            if (EN && !active) begin
                // Start new reception
                active <= 1;
                tick_counter <= 0;
                bit_index <= 0;
                PARALLELISER_DONE <= 0;
            end

            if (active && RX_tick) begin
                tick_counter <= tick_counter + 1;

                // Sample at middle of bit
                if (tick_counter == 4'd7) begin
                    PARALLEL_DATA[bit_index] <= SER_DATA;
                end

                // End of bit: go to next
                if (tick_counter == 4'd15) begin
                    tick_counter <= 0;

                    if (bit_index == 3'd7) begin
                        PARALLELISER_DONE <= 1;
                        active <= 0;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end
            end

            // Reset when EN goes low
            if (!EN) begin
                tick_counter      <= 0;
                bit_index         <= 0;
                PARALLELISER_DONE <= 0;
                active            <= 0;
            end
        end
    end
endmodule

