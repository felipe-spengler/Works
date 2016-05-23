// Trabalho 7 - Update
module sign(
	input [11:0]ptx,
	input [11:0]pty,
	input [11:0]p1x,
	input [11:0]p1y,
	input [11:0]p2x,
	input [11:0]p2y,
	output o
	);
	wire signed [11:0] a1;
	wire signed [11:0] a2;
	wire signed [11:0] a3;
	wire signed [11:0] a4;
	wire signed [23:0] m1;
	wire signed [23:0] m2;

	assign a1 = ptx - p2x;
	assign a2 = p1y - p2y;
	assign a3 = p1x - p2x;
	assign a4 = pty - p2y;
	assign m1 = a1 * a2;
	assign m2 = a3 * a4;
	assign o = m1 < m2;

endmodule

module ROM(
	input [4:0]end_triangulo,
	output [11:0]p1x,
	output [11:0]p1y,
	output [11:0]p2x,
	output [11:0]p2y,
	output [11:0]p3x,
	output [11:0]p3y
);

	reg [11:0]p1x_r;
	reg [11:0]p1y_r;
	reg [11:0]p2x_r;
	reg [11:0]p2y_r;
	reg [11:0]p3x_r;
	reg [11:0]p3y_r;

	assign p1x = p1x_r;
	assign p1y = p1y_r;
	assign p2x = p2x_r;
	assign p2y = p2y_r;
	assign p3x = p3x_r;
	assign p3y = p3y_r;

	always @(end_triangulo) begin
		case(end_triangulo)
			0:begin
				p1x_r <= 23;
				p1y_r <= 79;
				p2x_r <= 15;
				p2y_r <= 68;
				p3x_r <= 36;
				p3y_r <= 94;
			end
			1:begin
				p1x_r <= 23;
				p1y_r <= 34;
				p2x_r <= 55;
				p2y_r <= 31;
				p3x_r <= 96;
				p3y_r <= 45;
			end
			2:begin
				p1x_r <= 77;
				p1y_r <= 32;
				p2x_r <= 15;
				p2y_r <= 88;
				p3x_r <= 36;
				p3y_r <= 46;
			end
		endcase
	end
	
endmodule
module video_1(
	input clk,
	input w,
	input [11:0]end_x,
	input [11:0]end_y,
	input data,
	output saida
);
	
	reg memoria_video_1 [0:479] [0:639];
	reg saida_r;
	assign saida = memoria_video_1 [end_x][end_y];
	always @(posedge clk)begin
		if (w == 1) memoria_video_1 [end_x][end_y] = data;
		//$display("Gravou");
		
	end
endmodule
//module newTrab7(input CLOCK_50);
module newTrab7;
	
	reg clk = 0;
	reg write = 1;

	reg [11:0]p1x;
	reg [11:0]p1y;
	reg [11:0]p2x;
	reg [11:0]p2y;
	reg [11:0]p3x;
	reg [11:0]p3y;
	
	reg [11:0]ptx;
	reg [11:0]pty;

	reg [11:0]i;
	reg [11:0]j;
	
	wire [11:0]ptx_w;
	wire [11:0]pty_w;
	wire [11:0]p1x_w;
	wire [11:0]p1y_w;
	wire [11:0]p2x_w;
	wire [11:0]p2y_w;
	wire [11:0]p3x_w;
	wire [11:0]p3y_w;	

	reg [3:0]count = 0;
	reg [4:0]end_triangulo = 0;
	wire P1, P2, P3;
	reg saida;
	wire data;

	reg pode_ler = 0;

	sign Pt1(ptx, pty, p1x, p1y, p2x, p2y, P1);
	sign Pt2(ptx, pty, p2x, p2y, p3x, p3y, P2);
	sign Pt3(ptx, pty, p3x, p3y, p1x, p1y, P3);
	ROM R(end_triangulo, p1x_w, p1y_w, p2x_w, p2y_w, p3x_w, p3y_w);
	video_1 V(clk, write, i, j, saida, data);

	always #1 clk = ~clk;
	always @(posedge clk)begin
	//always @(posedge CLOCK_50) begin
		case(count)
			0:begin
				end_triangulo <= 0;
				count <= 1;
			end
			1: begin
				$display (" Triangulo %d", end_triangulo);
				p1x <= p1x_w;
				p1y <= p1y_w;
				p2x <= p2x_w;
				p2y <= p2y_w;
				p3x <= p3x_w;
				p3y <= p3y_w;	

				i <= 0;
				j <= 0;
				count <= 2;
				if (end_triangulo > 2) write <= 0;
				else write <= 1;
			end

			
			2: begin
				if (i < 480)begin
					count <= 3;
					j <= 0;
					
				end
		    		else count <= 4;
			end
			3: begin
				if (j < 640)begin
					//$display (" i = %d - j = %d" , i , j);
					//$display ("grava = %d" ,saida);
					// sempe alterar aqui (dentro for)
					ptx <= i;
					pty <= j;
					saida <= P1 == P2 & P2 == P3;
					if (pode_ler == 1) $display("data : %d", data);	
					//altera até aqui (dentro for)
					j <= j + 1;
					count <= 3;	
				end
				else begin
					i <= i + 1;
					count = 2;
				end
			end
			4: begin
				count <= 5;
				write <= 0;
			end


			5: begin
				if (pode_ler == 0) pode_ler <= 1;
				end_triangulo <= end_triangulo + 1;
				count <= 6;
			end
			6:begin
				if (end_triangulo > 3) $finish;
				else count <= 1;
			end
			
		endcase
	end	

endmodule
