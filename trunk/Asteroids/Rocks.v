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
output reg inUse);

//initial_x and initial_y should be chosen randomly by a fibonnaci random number generator

/* Registers */
// Rock's position on the screen
reg [9:0] rockX;
reg [9:0] rockY;

always @ (posedge clk60hz) begin
	// Initialization
	if ( start == 1'b1 ) begin
		inUse <= 1'b1;
		rockX <= initialX;
		rockY <= initialY;
	end else if ( reset == 1'b1 ) begin
		inUse <= 1'b0;
	end

	// Movement
	if ( inUse == 1'b1 ) begin
		if (dirX[2] == 1'b0) begin
				rockX <= rockX + dirX[1:0];
		end else begin
				rockX <= rockX - dirX[1:0];
		end
		
		if (dirY[2] == 1'b0) begin
			rockY <= rockY + dirY[1:0];
		end else begin
			rockY <= rockY - dirY[1:0];
		end
	end
end


/* Display generator */
always @(px)
begin
	if((px-12)<rockX && (px+12)>rockX && (py-10)<rockY&& (py+10)>rockY )
		pixel=1'b1;
	else if((px-10)<rockX && (px+10)>rockX && (py-12)<rockY&& (py+12)>rockY )
	else pixel=1'b0;
		pixel=1'b1;
end

endmodule
