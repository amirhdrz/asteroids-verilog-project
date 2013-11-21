module clk_60hz (input clk, output reg q);

reg [18:0] counter=19'b0000000000000000000;
	always @ (posedge clk) begin
		counter <= counter + 1;
		
		if (counter == 450000) begin
			q <= 1;
			counter <=0;
		end
		else q <= 0;
		
	end
		

endmodule
