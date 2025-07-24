module PARALLELISER (
/****************INPUTS****************/
input	wire		CLK,
input	wire		RST,
input	wire		SER_DATA,
input	wire		EN,
input	wire		RX_tick,
input	wire		TICK_EN,
/****************OUTPUTS****************/
output	reg		PARALLELISER_DONE,
output	reg	[7:0]	PARALLEL_DATA
);
/****************SIGNALS****************/	
reg	[2:0]	Counter;
reg			done;

/****************SEQUENTIAL_ALWAYS_BLOCKS****************/
always @ (posedge CLK or negedge RST)
	begin
		if (!RST)
			begin
				PARALLEL_DATA      <= 8'b0;
				PARALLELISER_DONE  <= 1'b0;
				Counter            <= 3'b0;
				done               <= 1'b0;
			end
		else if (EN && TICK_EN && RX_tick)
			begin
				if (!PARALLELISER_DONE)
					begin
						PARALLEL_DATA[Counter] <= SER_DATA;
						if (Counter == 3'd7)
							begin
								PARALLELISER_DONE <= 1'b1; 
							end
						else
							begin
								Counter <= Counter + 1;
							end
					end

			end
		else if (!EN) 
			begin
				Counter            <= 0;
				PARALLELISER_DONE  <= 0;
				done               <= 0;
			end
	end
endmodule

