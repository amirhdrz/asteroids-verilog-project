module Spaceship(
input [9:0] px,
input [9:0] py,
input clk_60hz, 

input left, 
input right,
input reset,

input [3:0] bullets,

output reg pixel,
output [9:0]shipXOut);

reg [9:0] shipX = 10'd320;
reg [9:0] shipY = 10'd240;

// Send out a signal containing ships current position
assign shipXOut = shipX + 10'd16;

/* Movement and reset*/
always @(posedge clk_60hz or posedge reset) begin
	
	if(reset)begin
		shipX <= 10'd320;
		shipY <= 10'd240;
	end else begin
		if(left && (shipX > 10'd30)) begin
			shipX <= shipX - 10'd3;
		end
		else if(right && (shipX < 10'd628)) begin
			shipX <= shipX + 10'd3;
		end
	end
end


/* Display generator */
/*always @(px)
begin
	if((px-15)<shipX && (px+15)>shipX&&(py-6)<shipY && (py+6)>shipY )
		pixel=1'b1;
	else if((px-1)<shipX && (px+1)>shipX&&(py-7)<shipY && (py+7)>shipY )
		pixel=1'b1;
	else pixel=1'b0;
end
*/

always @(px) begin
	if( (py==shipY) && px>=(shipX+10) && px<=(shipX+22))
		pixel=1'b1;
	else if( (py == (shipY+1)) && px>=(shipX+6) && px<=(shipX+26) )
		pixel=1'b1;
	else if( (py == (shipY+2)) && px>=(shipX+4) && px<=(shipX+28))
		pixel=1'b1;
			
	else if( (py == (shipY+3)) && px>=(shipX+2) && px<=(shipX+30))
		pixel=1'b1;
	else if( (py == (shipY+4)) && px>=(shipX+2) && px<=(shipX+30))
		pixel=1'b1;
	else if( (py == (shipY+5)) && px>=(shipX+2) && px<=(shipX+30))
		pixel=1'b1;
	else if( (py == (shipY+6)) && px>=(shipX+2) && px<=(shipX+30))
		pixel=1'b1;
	else if( (py == (shipY+7)) && px>=(shipX+2) && px<=(shipX+30))
		pixel=1'b1;
	else if( (py == (shipY+8)) && px>=(shipX+2) && px<=(shipX+30))
		pixel=1'b1;
		
	else if( (py == (shipY+9)) && px>=(shipX+4) && px<=(shipX+28))
		pixel=1'b1;
	else if( (py == (shipY+10)) && px>=(shipX+6) && px<=(shipX+26))
		pixel=1'b1;
	else if( (py == (shipY+11)) && px>=(shipX+10) && px<=(shipX+22))
		pixel=1'b1;
	else
		pixel=1'b0;
		
	/* Bullet holes */
	if( py>=(shipY+4) && py<=(shipY+8) && px>=(shipX+11) && px<=(shipX+12) )
		pixel = ~bullets[0];
	if( py>=(shipY+4) && py<=(shipY+8) && px>=(shipX+14) && px<=(shipX+15) )
		pixel = ~bullets[1];	
	if( py>=(shipY+4) && py<=(shipY+8) && px>=(shipX+17) && px<=(shipX+18) )
		pixel = ~bullets[2];
	if( py>=(shipY+4) && py<=(shipY+8) && px>=(shipX+20) && px<=(shipX+21) )
		pixel = ~bullets[3];
end

endmodule
