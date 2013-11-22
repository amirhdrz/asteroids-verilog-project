module Spaceship(
input [9:0] x,
input [9:0] y,
input clk_60hz, 

input left, 
input right,
input reset,

output reg pixel,
output [9:0]shipX2);

reg [9:0] shipX = 10'd320;
reg [9:0] shipY = 10'd240;

assign shipX2 = shipX;

always @(posedge clk_60hz) begin
	if(reset)begin
		shipX <= 10'd320;
		shipY <= 10'd240;
	end
	
	if(left && (shipX<12))
		shipX <= shipX-2;
	else if(right&& (shipX>628))
		shipX <= shipX+2;
end


/* Display generator */
always @(x)
begin
	
	if((x-10)<shipX && (x+10)>shipX&&(y-10)<shipY && (y+10)>shipY )
		pixel=1'b1;
	else if((x-1)<shipX && (x+1)>shipX&&(y-12)<shipY && (y+12)>shipY )
		pixel=1'b1;
	else pixel=1'b0;

end

endmodule
