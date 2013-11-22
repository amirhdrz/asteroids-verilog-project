module Bullet(
input [9:0] x,
input [9:0] y,
input clk_60hz,

input direction,
input start_bullet,
input reset,
input [9:0]shipX,

output BW,
output inUse
); 
	assign BW = ((x-1)<bulletX && (x+1)>bulletX && (y-1)<bulletY&&(y+1)>bulletY);
	
	assign inUse= inUse1;
	
	reg inUse1=0;
	reg[9:0] bulletX,bulletY;
	reg bullet_direction;
	
	always @(clk_60hz) begin
		if (reset||
			inUse1 && direction && (bulletY> 9'd480)||
			inUse1 && ~direction && (bulletY> 9'd0)) begin
				inUse1 = 1'b0;
				bulletX = 9'd800;		
				bulletY = 9'd500;		
			end
		else if (start_bullet&& ~inUse1)begin
			inUse1 = 1'b1;
			bulletX = shipX;
			bulletY = 9'd240;
			bullet_direction = direction;
			end
		else if(bullet_direction)
			bulletY=bulletY+2;
		else
			bulletY=bulletY-2;
		
	end
	
endmodule