module Bullet(
input [9:0] px,
input [9:0] py,
input clk_60hz,

input start_bullet,
input direction, // high for going up, low for going down
input reset,
input [9:0]shipX,

output reg pixel,
output reg inUse
); 

// Registers holding bullet positon
reg [9:0] bulletX;
reg [9:0] bulletY;
reg bullet_direction;

/* Movement generator and initialization based on 60hz clock and reset */
always @(posedge clk_60hz or posedge reset) begin

	if (reset) begin
		inUse <= 1'b0;
	end else begin
		if (~inUse && start_bullet) begin
			// if not in use and start signal is high, initialize
			inUse = 1'b1;
			bullet_direction <= direction;
			bulletX <= shipX;
			bulletY <= 10'd240;
		end else if (inUse) begin
			// if inUse, calculate the next coordinates
			if(bullet_direction == 1'b1)
				bulletY <= bulletY - 10'd6;
			else if (bullet_direction == 1'b0)
				bulletY <= bulletY + 10'd6;
		end
	end	
end

/* Display Generator */
always @ (px) begin
	pixel = 1'b0;
	if (inUse) begin
		if((px-2)<bulletX && (px+2)>bulletX && (py-6)<bulletY && (py+6)>bulletY ) begin
				pixel = 1'b1;
		end
	end
end


endmodule
