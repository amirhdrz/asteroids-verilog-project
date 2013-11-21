module Spaceship(
input [9:0] x,
input [9:0] y,
output [9:0] red, 
output [9:0] green, 
output [9:0] blue,
input clk, 
input left, 
input right);
	
reg block;
reg [9:0] shipX = 10'd320;
reg [9:0] shipY = 10'd240;

wire sample_clk;

clk_60hz (clk,sample_clk);

/* Movement */
// Sample user input to go left or right
always @(posedge sample_clk) begin
	if(left)
		shipX <= shipX-2;
	if(right)
		shipX <= shipX+2;
end

/* Display generator */
always @(x)
begin
	
	if((x-10)<shipX && (x+10)>shipX&&(y-10)<shipY&& (y+10)>shipY )
		block=1'b1;
	else if((x-1)<shipX && (x+1)>shipX&&(y-12)<shipY&& (y+12)>shipY )
		block=1'b1;
	else block=1'b0;

end

assign red = (block? 10'h3ff: 10'h000);
assign green = (block? 10'h3ff: 10'h000);
assign blue = (block? 10'h3ff: 10'h000);

endmodule
