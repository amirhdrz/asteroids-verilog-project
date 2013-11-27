module clk_60hz (input clk_27mhz, output reg q);

reg [18:0] counter=19'b0000000000000000000;
	always @ (posedge clk_27mhz) begin
		counter <= counter + 1;
		
		if (counter == 280000) begin
			q <= 1;
			counter <=0;
		end
		else q <= 0;
		
	end
		
endmodule
