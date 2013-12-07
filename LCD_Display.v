


        
module LCD_Display(iCLK_50MHZ, iRST_N,hex0,hex1,hex2,hex3, hex4, hex5,hex6,
    LCD_RS,LCD_E,LCD_RW,DATA_BUS);
input iCLK_50MHZ, iRST_N;
input [3:0] hex1, hex0,hex2,hex3, hex4, hex5,hex6;
output LCD_RS, LCD_E, LCD_RW;
inout [7:0] DATA_BUS;

parameter
HOLD = 4'h0,
FUNC_SET = 4'h1,
DISPLAY_ON = 4'h2,
MODE_SET = 4'h3,
Print_String = 4'h4,
LINE2 = 4'h5,
RETURN_HOME = 4'h6,
DROP_LCD_E = 4'h7,
RESET1 = 4'h8,
RESET2 = 4'h9,
RESET3 = 4'ha,
DISPLAY_OFF = 4'hb,
DISPLAY_CLEAR = 4'hc;

reg [3:0] state, next_command;
// Enter new ASCII hex data above for LCD Display
reg [7:0] DATA_BUS_VALUE;
wire [7:0] Next_Char;
reg [19:0] CLK_COUNT_400HZ;
reg [4:0] CHAR_COUNT;
reg CLK_400HZ, LCD_RW_INT, LCD_E, LCD_RS;

// BIDIRECTIONAL TRI STATE LCD DATA BUS
assign DATA_BUS = (LCD_RW_INT? 8'bZZZZZZZZ: DATA_BUS_VALUE);

LCD_display_string u1(
.index(CHAR_COUNT),
.out(Next_Char),
.hex0(hex0),
.hex1(hex1),
.hex2(hex2),
.hex3(hex3),
.hex4(hex4),
.hex5(hex5),
.hex6(hex6));

assign LCD_RW = LCD_RW_INT;

always @(posedge iCLK_50MHZ or negedge iRST_N)
    if (!iRST_N)
    begin
       CLK_COUNT_400HZ <= 20'h00000;
       CLK_400HZ <= 1'b0;
    end
    else if (CLK_COUNT_400HZ < 20'h0F424)
    begin
       CLK_COUNT_400HZ <= CLK_COUNT_400HZ + 1'b1;
    end
    else
    begin
      CLK_COUNT_400HZ <= 20'h00000;
      CLK_400HZ <= ~CLK_400HZ;
    end
// State Machine to send commands and data to LCD DISPLAY

always @(posedge CLK_400HZ or negedge iRST_N)
    if (!iRST_N)
    begin
     state <= RESET1;
    end
    else
    case (state)
    RESET1:            
// Set Function to 8-bit transfer and 2 line display with 5x8 Font size
// see Hitachi HD44780 family data sheet for LCD command and timing details
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h38;
      state <= DROP_LCD_E;
      next_command <= RESET2;
      CHAR_COUNT <= 5'b00000;
    end
    RESET2:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h38;
      state <= DROP_LCD_E;
      next_command <= RESET3;
    end
    RESET3:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h38;
      state <= DROP_LCD_E;
      next_command <= FUNC_SET;
    end
// EXTRA STATES ABOVE ARE NEEDED FOR RELIABLE PUSHBUTTON RESET OF LCD

    FUNC_SET:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h38;
      state <= DROP_LCD_E;
      next_command <= DISPLAY_OFF;
    end

// Turn off Display and Turn off cursor
    DISPLAY_OFF:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h08;
      state <= DROP_LCD_E;
      next_command <= DISPLAY_CLEAR;
    end

// Clear Display and Turn off cursor
    DISPLAY_CLEAR:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h01;
      state <= DROP_LCD_E;
      next_command <= DISPLAY_ON;
    end

// Turn on Display and Turn off cursor
    DISPLAY_ON:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h0C;
      state <= DROP_LCD_E;
      next_command <= MODE_SET;
    end

// Set write mode to auto increment address and move cursor to the right
    MODE_SET:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h06;
      state <= DROP_LCD_E;
      next_command <= Print_String;
    end

// Write ASCII hex character in first LCD character location
    Print_String:
    begin
      state <= DROP_LCD_E;
      LCD_E <= 1'b1;
      LCD_RS <= 1'b1;
      LCD_RW_INT <= 1'b0;
    // ASCII character to output
      if (Next_Char[7:4] != 4'h0)
        DATA_BUS_VALUE <= Next_Char;
        // Convert 4-bit value to an ASCII hex digit
      else if (Next_Char[3:0] >9)
        // ASCII A...F
         DATA_BUS_VALUE <= {4'h4,Next_Char[3:0]-4'h9};
      else
        // ASCII 0...9
         DATA_BUS_VALUE <= {4'h3,Next_Char[3:0]};
    // Loop to send out 32 characters to LCD Display  (16 by 2 lines)
      if ((CHAR_COUNT < 31) && (Next_Char != 8'hFE))
         CHAR_COUNT <= CHAR_COUNT + 1'b1;
      else
         CHAR_COUNT <= 5'b00000; 
    // Jump to second line?
      if (CHAR_COUNT == 15)
        next_command <= LINE2;
    // Return to first line?
      else if ((CHAR_COUNT == 31) || (Next_Char == 8'hFE))
        next_command <= RETURN_HOME;
      else
        next_command <= Print_String;
    end

// Set write address to line 2 character 1
    LINE2:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'hC0;
      state <= DROP_LCD_E;
      next_command <= Print_String;
    end

// Return write address to first character postion on line 1
    RETURN_HOME:
    begin
      LCD_E <= 1'b1;
      LCD_RS <= 1'b0;
      LCD_RW_INT <= 1'b0;
      DATA_BUS_VALUE <= 8'h80;
      state <= DROP_LCD_E;
      next_command <= Print_String;
    end

// The next three states occur at the end of each command or data transfer to the LCD
// Drop LCD E line - falling edge loads inst/data to LCD controller
    DROP_LCD_E:
    begin
      LCD_E <= 1'b0;
      state <= HOLD;
    end
// Hold LCD inst/data valid after falling edge of E line                
    HOLD:
    begin
      state <= next_command;
    end
    endcase
endmodule

module LCD_display_string(index,out,hex0, hex1, hex2, hex3, hex4, hex5,hex6);
input [4:0] index;
input [3:0] hex0, hex1, hex2, hex3, hex4, hex5,hex6;
output [7:0] out;
reg [7:0] out;
// ASCII hex values for LCD Display

/*
------------------------------------------------------------------- 
--                        ASCII HEX TABLE
--  Hex                        Low Hex Digit
-- Value  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
------\----------------------------------------------------------------
--H  2 |  SP  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
--i  3 |  0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
--g  4 |  @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
--h  5 |  P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
--   6 |  `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
--   7 |  p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~ DEL
-----------------------------------------------------------------------
-- Example "A" is row 4 column 1, so hex value is 8'h41"
-- *see LCD Controller's Datasheet for other graphics characters available
*/

// Line 1
   always 
     case (index)
   
    5'h00: out <= 8'h53;
    5'h01: out <= 8'h43;
    5'h02: out <= 8'h4F;
    5'h03: out <= 8'h52;
    5'h04: out <= 8'h45;
    5'h05: out <= 8'h3A;
    5'h06: out <= {4'h3,hex0};
    5'h07: out <= {4'h3,hex1};
    5'h08: out <= {4'h3,hex2};  
    5'h09: out <= 8'h30;
    5'h0A: out <= 8'h30;
    5'h0B: out <= 8'h20;  //space
    5'h0C: out <= 8'h3C;
    5'h0D: out <= 8'h33;
    5'h0E: out <= 8'h3A;
    5'h0F: out <= {4'h3,hex6};


    5'h10: out <= 8'h48;
    5'h11: out <= 8'h49;
    5'h12: out <= 8'h2D;
    5'h13: out <= 8'h53;
    5'h14: out <= 8'h43;
    5'h15: out <= 8'h4F;
    5'h16: out <= 8'h52;
    5'h17: out <= 8'h45;
    5'h18: out <= 8'h3A;
    5'h19: out <= {4'h3,hex3};
    5'h1A: out <= {4'h3,hex4};
    5'h1B: out <= {4'h3,hex5};  
    5'h1C: out <= 8'h30;
    5'h1D: out <= 8'h30;
    default: out <= 8'h20;
     endcase
endmodule