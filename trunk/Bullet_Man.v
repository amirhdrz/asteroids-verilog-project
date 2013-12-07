module Bullet_Man(
input [9:0] px,
input [9:0] py,
input clk_60hz,

input [9:0]shipX,
input shootUp,
input shootDown,
input [3:0]reset,

output [3:0] inUse,
output [3:0]pixel
);

wire direction;
assign direction = shootUp;

Bullet B0(
	.px(px),
	.py(py),
	.clk_60hz(clk_60hz),
	.direction(direction),
	.start_bullet(fire[0]),
	.reset(reset[0]),
	.shipX(shipX),
	//outputs
	.pixel(pixel[0]),
	.inUse(inUse[0])
);

Bullet B1(
	.px(px),
	.py(py),
	.clk_60hz(clk_60hz),
	.direction(direction),
	.start_bullet(fire[1]),
	.reset(reset[1]),
	.shipX(shipX),
	.pixel(pixel[1]),
	.inUse(inUse[1])
);
Bullet B2(
	.px(px),
	.py(py),
	.clk_60hz(clk_60hz),
	.direction(direction),
	.start_bullet(fire[2]),
	.reset(reset[2]),
	.shipX(shipX),
	.pixel(pixel[2]),
	.inUse(inUse[2])
);
Bullet B3(
	.px(px),
	.py(py),
	.clk_60hz(clk_60hz),
	.direction(direction),
	.start_bullet(fire[3]),
	.reset(reset[3]),
	.shipX(shipX),
	.pixel(pixel[3]),
	.inUse(inUse[3])
);

/* Shooting mechanism */
wire shoot = (shootUp || shootDown);
reg [3:0] fire;
reg prvCycleShoot = 1'b0;

always @ (posedge clk_60hz) begin
	fire = 4'b0000;
	if (~prvCycleShoot) begin
		if (shoot) begin
			prvCycleShoot = 1'b1;
			if (~inUse[0])
				fire[0] = 1'b1;
			else if (~inUse[1])
				fire[1] = 1'b1;
			else if (~inUse[2])
				fire[2] = 1'b1;
			else if (~inUse[3])
				fire[3] = 1'b1;
		end
	end else if (~shoot)
		prvCycleShoot <= 1'b0;
end

endmodule
