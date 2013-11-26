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
reg [9:0] bulletX;// = 10'd320;//DEBUG
reg [9:0] bulletY;// = 10'd240;//DEBUG
reg bullet_direction;
reg border = 1'b0;

/* Movement generator and initialization based on 60hz clock and reset */
always @(posedge clk_60hz or posedge reset) begin

	if (reset) begin
		inUse <= 1'b0;
	end
	else if (border) begin
		inUse <= 1'b0;
		border <= 1'b0;
	end
	else begin
		if (~inUse && start_bullet) begin
			// if not in use and start signal is high, initialize
			inUse = 1'b1;
			bullet_direction <= direction;
			bulletX <= shipX;
			bulletY <= 10'd240;
		end else if (inUse) begin
			// if inUse, calculate the next coordinates
			if(bullet_direction == 1'b1)
				bulletY <= bulletY - 10'd2;
			else if (bullet_direction == 1'b0)
				bulletY <= bulletY + 10'd2;
			if (bulletY > 480)
				border <= 1'b1;
		end
	end	
end

/* Display Generator */
always @ (px) begin
		if((px-4)<bulletX && (px+4)>bulletX && (py-8)<bulletY && (py+8)>bulletY ) begin
			if (inUse)
				pixel = 1'b1;
		end else
			pixel = 1'b0;
end


endmodule
