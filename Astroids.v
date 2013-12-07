module Astroids(
//	Clock Input
  input CLOCK_50,	//	50 MHz
  input CLOCK_27,     //      27 MHz
//	Push Button
  input [3:0] KEY,      //	Pushbutton[3:0]
//	DPDT Switch
  input [17:0] SW,		//	Toggle Switch[17:0]
//	7-SEG Display
  output [6:0]	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,  // Seven Segment Digits
//	LED
  output [8:0]	LEDG,  //	LED Green[8:0]
  output [17:0] LEDR,  //	LED Red[17:0]
//	GPIO
 inout [35:0] GPIO_0,GPIO_1,	//	GPIO Connections
//	TV Decoder
//TD_DATA,    	//	TV Decoder Data bus 8 bits
//TD_HS,		//	TV Decoder H_SYNC
//TD_VS,		//	TV Decoder V_SYNC
  output TD_RESET,	//	TV Decoder Reset
// VGA
  output VGA_CLK,   						//	VGA Clock
  output VGA_HS,							//	VGA H_SYNC
  output VGA_VS,							//	VGA V_SYNC
  output VGA_BLANK,						//	VGA BLANK
  output VGA_SYNC,						//	VGA SYNC
  output [9:0] VGA_R,   						//	VGA Red[9:0]
  output [9:0] VGA_G,	 						//	VGA Green[9:0]
  output [9:0] VGA_B,   						//	VGA Blue[9:0]
  
//LCD Module 16X2
  output LCD_ON,    // LCD Power ON/OFF
  output LCD_BLON,    // LCD Back Light ON/OFF
  output LCD_RW,    // LCD Read/Write Select, 0 = Write, 1 = Read
  output LCD_EN,    // LCD Enable
  output LCD_RS,    // LCD Command/Data Select, 0 = Command, 1 = Data
  inout [7:0] LCD_DATA    // LCD Data bus 8 bits
);

//	All inout port turn to tri-state
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;


// turn LCD ON
assign    LCD_ON        =    1'b1;
assign    LCD_BLON    =    1'b1;

wire RST = 1'b1;

// reset delay gives some time for peripherals to initialize
wire DLY_RST;
Reset_Delay r0(	.iCLK(CLOCK_50),.oRESET(DLY_RST) );

wire [6:0] blank = 7'b111_1111;

// blank unused 7-segment digits
assign HEX0 = blank;
assign HEX1 = blank;
assign HEX2 = blank;
assign HEX3 = blank;
assign HEX4 = blank;
assign HEX5 = blank;
assign HEX6 = blank;
assign HEX7 = blank;
//================================================
/* Displaying high score */
//------------------------------------------------
//hex_7seg(current_score[3:0], HEX0);
//hex_7seg(current_score[7:4], HEX1);
//hex_7seg(current_score[11:8], HEX2);
//hex_7seg(current_score[15:12], HEX3);
//hex_7seg({2'b00,lives}, HEX7);

wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [9:0]	mCoord_X;
wire [9:0]	mCoord_Y;

assign	TD_RESET = 1'b1; // Enable 27 MHz

VGA_Audio_PLL 	p1 (	
	.areset(~DLY_RST),
	.inclk0(CLOCK_27),
	.c0(VGA_CTRL_CLK),
	.c1(AUD_CTRL_CLK),
	.c2(VGA_CLK)
);
//=========================================================================
/* Our code starts here */
//=========================================================================
// shipX connects to register holding
// current X coordinate of the spaceship
wire [9:0]shipX;

// This wire contains signal for pixel data
// from each module
wire [15:0]BW;

/* 60Hz clock that logic of the game uses */
wire sample_clk;
clk_60hz (CLOCK_27,sample_clk);

/* Signals and Registers*/
reg [15:0] high_score;        ////////
wire [14:0] reset;
wire [15:0] current_score;
wire [1:0] lives; //change
wire game_over;
wire reset_game = SW[17];
wire [3:0] bullets; //Bullts in use

/* For when player wants a new game */
/*always @ (posedge new_game) begin
	//current_score <= 16'b0;
	//current_lives <= 2'd3;
end*/

/* Set high score when game ends */
always @ (posedge game_over) begin
		if (high_score< current_score)
		high_score <= current_score;
end

/* Spaceship */
Spaceship c1(
	.px(mCoord_X),
	.py(mCoord_Y),
	.clk_60hz(sample_clk),
	.left(~KEY[3]),
	.right(~KEY[2]),
	.reset(reset[0]),
	.bullets(bullets),
	//outputs
	.pixel(BW[0]),
	.shipXOut(shipX)
);

/* Bullets manager */
Bullet_Man Bm1(
	//input
	.px(mCoord_X),
	.py(mCoord_Y),
	.clk_60hz(sample_clk),
	.shipX(shipX),
	.shootUp(~KEY[1]),
	.shootDown(~KEY[0]),
	.reset(reset[4:1]),
	//output
	.inUse(bullets),
	.pixel(BW[4:1])
);

/* Rocks manager */
Rocks_Man(
	.px(mCoord_X),
	.py(mCoord_Y),
	.clk60hz(sample_clk),
	.reset(reset[14:5]),
	.pixel(BW[14:5])
);

/* Collision detector and score and life counter */
collision_detector(
	//inputs
	.clk_60hz(sample_clk),
	.px(mCoord_X),
	.py(mCoord_Y),
	.pixels(BW), // pixel signal from all objects
	.reset_game(reset_game),
	//outputs
	.reset(reset), // reset signal to all objects
	.game_over(game_over), // goes high when number of lives reaches zero
	.score(current_score),
	.lives(lives)
);

/* Convert pixel values to RGB */
wire pixel = |BW;



assign mVGA_R = (game_over?  10'h3ff :(pixel? 10'h3ff : 10'h000));
assign mVGA_G = (game_over?  10'h300 :(pixel? 10'h3ff : 10'h000));
assign mVGA_B = (game_over?  10'h300 :(pixel? 10'h3ff : 10'h000));

vga_sync u1(
   .iCLK(VGA_CTRL_CLK),
   .iRST_N(DLY_RST),	
   .iRed(mVGA_R),
   .iGreen(mVGA_G),
   .iBlue(mVGA_B),
   // pixel coordinates
   .px(mCoord_X),
   .py(mCoord_Y),
   // VGA Side
   .VGA_R(VGA_R),
   .VGA_G(VGA_G),
   .VGA_B(VGA_B),
   .VGA_H_SYNC(VGA_HS),
   .VGA_V_SYNC(VGA_VS),
   .VGA_SYNC(VGA_SYNC),
   .VGA_BLANK(VGA_BLANK)
);

//LCD display

wire [3:0] current_score_o, current_score_t, current_score_h;
wire [3:0]hi_score_o, hi_score_t, hi_score_h;

binary_to_BCD bcd1 (current_score, current_score_o, current_score_t, current_score_h[0]);
binary_to_BCD bcd2 (high_score, hi_score_o, hi_score_t, hi_score_h[0]);

LCD_Display (
// Host Side
   .iCLK_50MHZ(CLOCK_50),
   .iRST_N(DLY_RST),
   .hex0(current_score_h),
   .hex1(current_score_t),
   .hex2(current_score_o),
   .hex3(hi_score_h),
   .hex4(hi_score_t),
   .hex5(hi_score_o),
   .hex6(lives),
// LCD Side
   .DATA_BUS(LCD_DATA),
   .LCD_RW(LCD_RW),
   .LCD_E(LCD_EN),
   .LCD_RS(LCD_RS)
);


endmodule