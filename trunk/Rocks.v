module Rocks(
input [9:0] px,
input [9:0] py,

// Initial position of the astroid
input [9:0] initialX,
input [9:0] initialY,

// Direction of travel
input [2:0] dirX,
input [2:0] dirY,

// Set to high to activate the astroid module
input start,

// Set to high to remove astroid from screen and deactivate
input reset,

// This clock is used for calculating next positin of the astroid(rock)
input clk60hz,

// Output pixel signal
output reg pixel,

// Output is high when this astroid is active
output reg inUse);

/* Registers */
// Rock's position and direction on the screen
reg [9:0] rockX, rockY;
reg [2:0] rockDirX, rockDirY;


/* Movement generator and initialization based on 60hz clock and reset */
always @ (posedge clk60hz or posedge reset) begin
	
	if (reset) begin
		inUse <= 1'b0;
	end else begin
		
		if (~inUse) begin
			// if not inUse and start signal is high, initialize
			if (start) begin
				inUse <= 1'b1;
				rockX <= initialX;
				rockY <= initialY;
				rockDirX <= dirX;
				rockDirY <= dirY;
			end
			
		end else begin
			// if in use, calculate next coordinates on 60hz clock
			if (rockDirX[2] == 1'b0) begin
					rockX <= rockX + rockDirX[1:0];
			end else begin
					rockX <= rockX - rockDirX[1:0];
			end
			
			if (rockDirY[2] == 1'b0) begin
				rockY <= rockY + rockDirY[1:0];
			end else begin
				rockY <= rockY - rockDirY[1:0];
			end
		end
	end //if (~reset)
end


/* Display generator */
/*
always @(px) begin
	pixel = 1'b0;
	if (inUse) begin
		if((px-12)<rockX && (px+12)>rockX && (py-10)<rockY&& (py+10)>rockY )
			pixel=1'b1;
		else if((px-10)<rockX && (px+10)>rockX && (py-12)<rockY&& (py+12)>rockY )
			pixel=1'b1;
		//else pixel=1'b0; DEBUG MAY NEED TO REVERT
	end
end*/

endmodule
