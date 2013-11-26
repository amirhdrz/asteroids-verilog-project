module collision_detector(
	input clk_60hz,
	input [14:0]pixel,
	output [14:0]reset);
	
	
	reg lives;
	reg score;
	
	always @ (posedge clk) begin
		if(|pixel[0] and |pixel[14:5]) begin
			reset = pixel;
		end
		else if (|pixel[4:1] and |pixel[14:5]) begin
			reset = pixel;
		end
		else begin
			reset = 14'b0;
		end
	end

end module