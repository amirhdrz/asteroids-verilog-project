module Spaceship(
input [9:0] px,
input [9:0] py,
input clk_60hz, 

input left, 
input right,
input reset,

output reg pixel,
output [9:0]shipXOut);

reg [9:0] shipX = 10'd320;
reg [9:0] shipY = 10'd240;

// Send out a signal containing ships current position
assign shipXOut = shipX;

/* Movement and reset*/
always @(posedge clk_60hz or posedge reset) begin
	
	if(reset)begin
		shipX <= 10'd320;
		shipY <= 10'd240;
	end else begin
		if(left && (shipX > 10'd12)) begin
			shipX <= shipX - 10'd2;
		end
		else if(right && (shipX < 10'd628)) begin
			shipX <= shipX + 10'd2;
		end
	end
end


/* Display generator */
always @(px)
begin
	
	if((px-15)<shipX && (px+15)>shipX&&(py-6)<shipY && (py+6)>shipY )
		pixel=1'b1;
	else if((px-1)<shipX && (px+1)>shipX&&(py-7)<shipY && (py+7)>shipY )
		pixel=1'b1;
	else pixel=1'b0;

end

endmodule
