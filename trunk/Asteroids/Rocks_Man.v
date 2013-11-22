module fib_16bit (Clk, Q);
	 input Clk;
	 output Q;
	 
	 reg [15:0]SEED = 16'b0010000100100001;
	 
	 always @(posedge Clk) begin
	  SEED<={SEED[14:0],SEED[10]^ (SEED[12]^  (SEED[13]^SEED[15])  ) };
	 end
	 
	 assign Q=SEED;
endmodule

/* Generates a random direction based on a 16 bit random input */
module randomDir(in, out);
	input [15:0] in;
	output [2:0] out;

	//NOTE: generates x01 half the time
	assign out[0] = ~in[1] | in[0];
	assign out[1] = in[1];
	assign out[2] = in[2];
endmodule

/* 2 second rocket generator */
module Clk2sec( input clk60hz, output reg q);
	reg [6:0] counter=7'b0000000;
	always @ (posedge clk60hz) begin
		counter <= counter + 1;
		
		if (counter == 120) begin
			q <= 1;
			counter <=0;
		end
		else q <= 0;
		
	end
endmodule

module Rocks_Man(
input [9:0] px,
input [9:0] py,
input clk60hz,

// reset signal from collision detector
input [9:0] reset,
output [9:0] pixel,
);

	wire [9:0] rocks_in_use;
	
	/* Random number generator */
	wire [15:0] randomX:
	wire [15:0] randomY;
	fib_16bit(clk60hz, randomX);
	fib_16bit(clk60hz, randomY);
	
	/* Random direction generator */
	wire [2:0] ranDirX;
	wire [2:0] ranDirY;
	randomDir(randomX, ranDirX);
	randomDir(randomY, ranDirY);
	
	/* Random rocket firing */
	wire spawn;
	reg [9:0] fire;
	Clk2sec(clk60hz, spawn);
	
	always @ (posedge spawn) begin
		//reset fire before firing again
		fire = 0;
		
		if (rocks_in_use[0] == 1'b0)
			fire[0] = 1'b1;
		else if (rocks_in_use[1] == 1'b0)
			fire[1] = 1'b1;
		else if (rocks_in_use[2] == 1'b0)
			fire[2] = 1'b1;
		else if (rocks_in_use[3] == 1'b0)
			fire[3] = 1'b1;
		else if (rocks_in_use[4] == 1'b0)
			fire[4] = 1'b1;
		else if (rocks_in_use[5] == 1'b0)
			fire[5] = 1'b1;
		else if (rocks_in_use[6] == 1'b0)
			fire[6] = 1'b1;
		else if (rocks_in_use[7] == 1'b0)
			fire[7] = 1'b1;
		else if (rocks_in_use[8] == 1'b0)
			fire[8] = 1'b1;
		else if (rocks_in_use[9] == 1'b0)
			fire[9] = 1'b1;			
	
	end
	
	/* Rock 0 */
	Rocks(
	//inputs
	.px(px),
	.py(py),
	.initialX(randomX[9:0]),
	.initialY(randomY[9:0]),
	.dirX(ranDirX),
	.dirY(ranDirY),
	.start(fire[0]),
	.reset(reset[0]),
	.clk60hz(clk60hz),
	//outputs
	.pixel(pixel[0]),
	.inUse(rocks_in_use[0]));
	
	/* Rock 1 */
	Rocks(
	//inputs
	.px(px),
	.py(py),
	.initialX(randomX[9:0]),
	.initialY(randomY[9:0]),
	.dirX(ranDirX),
	.dirY(ranDirY),
	.start(fire[1]),
	.reset(reset[1]),
	.clk60hz(clk60hz),
	//outputs
	.pixel(pixel[1]),
	.inUse(rocks_in_use[1]));


endmodule
