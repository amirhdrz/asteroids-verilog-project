module Bullet_Man(
input [9:0] x,
input [9:0] y,
input clk_60hz,

input [9:0]shipx,
input shootUp,
input shootDown,
input [3:0]reset,

output [3:0]BW
);

reg [3:0]direction;
reg [3:0]start_bullet;
wire fire_delay;
wire [3:0] inUse;

Bullet B0(
	.x(x),
	.y(y),
	.clk_60hz(clk_60hz),
	.direction(direction[0]),
	.start_bullet(start_bullet[0]),
	.reset(reset[0]),
	.BW(BW[0]),
	.inUse(inUse[0]),
	.shipX(shipX)
);
Bullet B1(
	.x(x),
	.y(y),
	.clk_60hz(clk_60hz),
	.direction(direction[1]),
	.start_bullet(start_bullet[1]),
	.reset(reset[1]),
	.BW(BW[1]),
	.inUse(inUse[1]),
	.shipX(shipX)
);
Bullet B2(
	.x(x),
	.y(y),
	.clk_60hz(clk_60hz),
	.direction(direction[2]),
	.start_bullet(start_bullet[2]),
	.reset(reset[2]),
	.BW(BW[2]),
	.inUse(inUse[2]),
	.shipX(shipX)
);
Bullet B3(
	.x(x),
	.y(y),
	.clk_60hz(clk_60hz),
	.direction(direction[3]),
	.start_bullet(start_bullet[3]),
	.reset(reset[3]),
	.BW(BW[3]),
	.inUse(inUse[3]),
	.shipX(shipX)
);


/*
clk_5seconds(
	clk_60hz,
	clk_5seconds,
	ready,
	start);
*/
wire shoot = (shootUp || shootDown);
always @(posedge shoot) begin
	direction= {shootUp,shootUp,shootUp,shootUp};
	if(~inUse[0]) begin
		start_bullet=4'b0001;
		//start=1;
		end
	else if(~inUse[1])begin
		start_bullet=4'b0010;end
		//start=1;
	else if(~inUse[2]) begin
		start_bullet=4'b0100;end
		//start=1;
	else if(~inUse[3]) begin
		start_bullet=4'b1000;end
		//start=1;
	else 
		start_bullet=4'b0;
	
end


endmodule
