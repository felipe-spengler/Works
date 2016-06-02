/*
Usar Clock_25
Contador até 800x525
VGA_HS negativo para H_Sync 660 até 756
Negativo para v 494 até 495

*/
module trab8(
	input CLOCK_50,
	output VGA_HS ,
	output VGA_VS,
	output VGA_R,
	output VGA_G,
	output VGA_B
);

	reg [3:0]Red;
	reg [3:0]Green;
	reg [3:0]Blue;
	reg V_Sync;
	reg H_Sync;
	reg [11:0]i;
	reg [11:0]j;
    reg CLK_25 = 0;
	reg [3:0]count = 0;

	assign VGA_R = Red;
	assign VGA_B = Blue;
	assign VGA_G = Green;

	assign VGA_HS = H_Sync;
	assign VGA_VS = V_Sync;
    always (posedge CLOCK_50) CLK_25 <= ~CLK_25;

	always @(posedge CLK_25) begin
		case(count)
			0:begin
				i <= 0;
				j <= 0;
				count <= 2;
			end


			2: begin
				if (i < 640)begin
					count <= 3;
					j <= 0;

				end
		    	else count <= 4;
			end
			3: begin
				if (j < 480)begin
					// sempe alterar aqui (dentro for)

					if (i  > 660 & i < 756) H_Sync <= 0;
					else H_Sync <= 1;
                    if (j  > 494 & j < 495) V_Sync <= 0;
					else V_Sync <= 1;

					if (i > 200 & j > 200 & i < 300 & j < 300)begin
						Red <= 4'b1;
						Green <= 4'b1;
						Blue <= 4'b1;
					end
					else begin
						Red <= 4'b0;
						Green <= 4'b0;
						Blue <= 4'b0;
					end
					//altera até aqui (dentro for)
					j <= j + 1;
					count <= 3;
				end
				else begin
					i <= i + 1;
					count <= 2;
				end
			end
		endcase
	end

endmodule
