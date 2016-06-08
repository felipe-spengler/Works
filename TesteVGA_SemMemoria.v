module testeMemoria(
		input CLOCK_50,
		input [3:0] KEY,
		output [3:0] VGA_R,
		output [3:0] VGA_G,
		output [3:0] VGA_B,
		output VGA_HS,
		output VGA_VS,
		output [7:0]LEDG
		);
		
	reg [18:0] i;
	reg [15:0] j;
	
	reg [3:0] Red;
	reg [3:0] Green;
	reg [3:0] Blue;
	
	reg CLK_25;
	reg clock_state;
	
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;
	assign VGA_HS = (i >= 660 && i <= 756) ? 0:1;
	assign VGA_VS = (j >= 494 && j <= 495) ? 0:1;
	
	always @(posedge CLOCK_50) begin
		if (clock_state == 0) begin
			CLK_25 = ~CLK_25;
		end
		else begin
			clock_state = ~clock_state;
		end
	end
	// contador de i e j
	always @(posedge CLK_25) begin
			if (i < 799) begin
				i <= i + 1;
			end
			else begin
				i <= 0;
				if (j < 524) begin
					j <= j + 1;
				end
				else begin
					j <= 0;
				end
			end
	end
	
	// Figura
	always @(i or j) begin
		if (j < 480 & i < 640) begin
			if (i > 300 & i < 400 & j > 300 & j < 400) begin
				Red <= 4'b1111;
				Green <= 4'b1111;
				Blue <= 4'b1111;
			end
			else begin
				Red <= 4'b1100;
				Green <= 4'b1100;
				Blue <= 4'b1100;
			end
		end
		else begin
			Red <= 4'b0000;
			Green <= 4'b0000;
			Blue <= 4'b0000;
		end

	end
endmodule
