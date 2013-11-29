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

/* New Rocks Display Generator */
always @(px) begin
	pixel=1'b0;
	
	if(inUse) begin
		if( (py==rockY) && px>=(rockX+8) && px<=(rockX+22))
			pixel=1'b1;
		else if( (py == (rockY+1)) && px>=(rockX+9) && px<=(rockX+24) )
			pixel=1'b1;
		else if( (py == (rockY+2)) && px>=(rockX+10) && px<=(rockX+25))
			pixel=1'b1;
		else if( (py == (rockY+3)) && px>=(rockX+10) && px<=(rockX+27))
			pixel=1'b1;
		else if( (py == (rockY+4)) && px>=(rockX+11) && px<=(rockX+29))
			pixel=1'b1;
		else if( (py == (rockY+5)) && px>=(rockX+12) && px<=(rockX+30))
			pixel=1'b1;
		else if( (py == (rockY+6)) && px>=(rockX+12) && px<=(rockX+32))
			pixel=1'b1;
		else if( (py == (rockY+7)) && px>=(rockX+0) && px<=(rockX+34))
			pixel=1'b1;
		else if( (py == (rockY+8)) && px>=(rockX+0) && px<=(rockX+34))
			pixel=1'b1;
		else if( (py == (rockY+9)) && px>=(rockX+0) && px<=(rockX+34))
			pixel=1'b1;
		else if( (py == (rockY+10)) && px>=(rockX+0) && px<=(rockX+34))
			pixel=1'b1;
		else if( (py == (rockY+11)) && px>=(rockX+0) && px<=(rockX+34))
			pixel=1'b1;
		else if( (py == (rockY+12)) && px>=(rockX+0) && px<=(rockX+32))
			pixel=1'b1;
		else if( (py == (rockY+13)) && px>=(rockX+0) && px<=(rockX+28))
			pixel=1'b1;
		else if( (py == (rockY+14)) && px>=(rockX+0) && px<=(rockX+24))
			pixel=1'b1;
		else if( (py == (rockY+15)) && px>=(rockX+0) && px<=(rockX+23))
			pixel=1'b1;
		else if( (py == (rockY+16)) && px>=(rockX+0) && px<=(rockX+24))
			pixel=1'b1;
		else if( (py == (rockY+17)) && px>=(rockX+0) && px<=(rockX+26))
			pixel=1'b1;
		else if( (py == (rockY+18)) && px>=(rockX+0) && px<=(rockX+28))
			pixel=1'b1;
		else if( (py == (rockY+19)) && px>=(rockX+0) && px<=(rockX+29))
			pixel=1'b1;
		else if( (py == (rockY+20)) && px>=(rockX+1) && px<=(rockX+30))
			pixel=1'b1;
		else if( (py == (rockY+21)) && px>=(rockX+2) && px<=(rockX+31))
			pixel=1'b1;
		else if( (py == (rockY+22)) && px>=(rockX+3) && px<=(rockX+32))
			pixel=1'b1;
		else if( (py == (rockY+23)) && px>=(rockX+3) && px<=(rockX+33))
			pixel=1'b1;
		else if( (py == (rockY+24)) && px>=(rockX+4) && px<=(rockX+32))
			pixel=1'b1;
		else if( (py == (rockY+25)) && px>=(rockX+5) && px<=(rockX+31))
			pixel=1'b1;
		else if( (py == (rockY+26)) && px>=(rockX+6) && px<=(rockX+30))
			pixel=1'b1;
		else if( (py == (rockY+27)) && px>=(rockX+6) && px<=(rockX+16))
			pixel=1'b1;
		else if( (py == (rockY+27)) && px>=(rockX+22) && px<=(rockX+29))
			pixel=1'b1;
		else if( (py == (rockY+28)) && px>=(rockX+7) && px<=(rockX+14))
			pixel=1'b1;
		else if( (py == (rockY+28)) && px>=(rockX+24) && px<=(rockX+28))
			pixel=1'b1;
		else if( (py == (rockY+29)) && px>=(rockX+8) && px<=(rockX+12))
			pixel=1'b1;
		else if( (py == (rockY+29)) && px>=(rockX+24) && px<=(rockX+26))
			pixel=1'b1;
		else if( (py == (rockY+30)) && px>=(rockX+8) && px<=(rockX+9))
			pixel=1'b1;
		else if( (py == (rockY+30)) && px>=(rockX+25) && px<=(rockX+26))
			pixel=1'b1;
	end
end

endmodule
