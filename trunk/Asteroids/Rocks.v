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
output pixel,

// Output is high when this astroid is active
output in_use);

/* initial_x and initial_y should be chosen randomly by a fibonnaci random number generator*/

// Rock's position on the screen
reg [9:0] rockX;
reg [9:0] rockY;

/* Movement generator */
always @ (posedge clk60hz) begin
	// TODO how to sign extend dirX and dirY, also, should they be in 2's complement?!
	// TODO implement reset too
	rockX <= rockX + dirX;
	rockY <= rockY + dirY;
end


/* Display generator */
always @(px)
begin
	if((px-12)<rockX && (px+12)>rockX && (py-10)<rockY&& (py+10)>rockY )
		pixel=1'b1;
	else if((px-10)<rockX && (px+10)>rockX && (py-12)<rockY&& (py+12)>rockY )
		pixel=1'b1;
	else pixel=1'b0;

end

endmodule
