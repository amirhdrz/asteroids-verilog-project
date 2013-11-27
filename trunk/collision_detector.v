module collision_detector(
	input clk_60hz,
	input [9:0] px,
	input [9:0] py,
	input [14:0] pixels, // pixel signal from all objects
	input reset_game,
	
	output reg [14:0]reset, // reset signal to all objects
	output reg game_over, // goes high when number of lives reaches zero
	output reg [15:0] score,
	output reg [1:0] lives
	);
	
	/* wires for collision detection */
	wire space_ship = pixels[0];
	wire bullets = |pixels[4:1];
	wire rocks = |pixels[14:5];
	
	always @ (posedge px or posedge reset_game) begin
	
		if (reset_game) begin
			// when the user resets the game
			game_over <= 1'b0;
			reset <= 15'b111111111111111; // reset all objects
			score <= 16'b0;
			lives <= 2'd3;
		end else begin
			// Reset reset signal
			reset = 15'b0; 
			
			// Screen border collision detection
			if ((px > 10'd660) || (py > 10'd500)) begin
				reset <= pixels;
			end else begin//
			
				// if bullets and rocks collide
				if (bullets && rocks) begin
					score <= score + 16'b1;
					reset <= pixels;
					
				// if space_ship and rocks collide
				end else if (space_ship && rocks) begin
					// if space_ship and rocks collide
					lives <= lives - 2'b1;
					reset <= pixels;
					if (lives == 2'b0)
						game_over <= 1'b1;
				end
			end
			
		end
	end

endmodule
