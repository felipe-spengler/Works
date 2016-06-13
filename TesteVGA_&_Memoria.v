module testeMemoria(
		input CLOCK_50,
		input [3:0] KEY,
		output [3:0] VGA_R,
		output [3:0] VGA_G,
		output [3:0] VGA_B,
		output VGA_HS,
		output VGA_VS,
		output [7:0]LEDG,
		output [17:0] SRAM_ADDR,
        inout [15:0] SRAM_DQ,
        output SRAM_WE_N,
        output SRAM_OE_N,
        output SRAM_UB_N,
        output SRAM_LB_N,
        output SRAM_CE_N
);

	reg [18:0] i;
	reg [15:0] j;

	reg [3:0] Red;
	reg [3:0] Green;
	reg [3:0] Blue;

	reg CLK_25;
	reg clock_state;

	reg leitura = 0;
	reg escrita = 1;

	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;
	assign VGA_HS = (i >= 660 && i <= 756) ? 0:1;
	assign VGA_VS = (j >= 494 && j <= 495) ? 0:1;

	// Clock 25 hz
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
			if (i < 800) begin
				i <= i + 1;
			end
			else begin
				i <= 0;
				if (j < 525) begin
					j <= j + 1;
				end
				else begin
					j <= 0;
				end
			end
	end

	// Leitura e Dados > VGA
	always @(posedge CLK_25) begin
	    if (leitura == 1)begin
            if (j < 480 && i < 640) begin
                oe <= 0;
                if (data_reg == 1)
                    Red <= 4'b1;
                    Green <= 4'b1;
                    Blue <= 4'b1;
                end
                else begin
                    Red <= 4'b0;
                    Green <= 4'b0;
                    Blue <= 4'b0;
                end
                addr_reg = addr_reg + 1;
            end
            else begin
                oe <= 1;
                Red <= 4'b0;
                Green <= 4'b0;
                Blue <= 4'b0;
            end
	    end
	end
	always @(CLK_25) begin
	    if (i == 800 && j ==  525)begin
            escrita = ~escrita;
            leitura = ~leitura;
	    end
	end
	// escrita de dados memoria
	always @(posedge CLK_25) begin
	    if (escrita== 1)begin
            if (j < 480 && i < 640) begin
                we <= 0;
                if (i > 300 & i < 400 & j > 300 & j < 400) data_reg <= 1;
                else data_reg <= 0;
            else
                we <= 1;

	    end
	end

endmodule
