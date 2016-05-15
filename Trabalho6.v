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
	input [4:0]end_ponto,
	output [11:0]p1x,
	output [11:0]p1y,
	output [11:0]p2x,
	output [11:0]p2y,
	output [11:0]p3x,
	output [11:0]p3y,
	output [11:0]ptx,
	output [11:0]pty
);

	reg [11:0]p1x_r;
	reg [11:0]p1y_r;
	reg [11:0]p2x_r;
	reg [11:0]p2y_r;
	reg [11:0]p3x_r;
	reg [11:0]p3y_r;

	reg [11:0]ptx_r;
	reg [11:0]pty_r;
	
	assign p1x = p1x_r;
	assign p1y = p1y_r;
	assign p2x = p2x_r;
	assign p2y = p2y_r;
	assign p3x = p3x_r;
	assign p3y = p3y_r;

	assign ptx = ptx_r;
	assign pty = pty_r;

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
	always @(end_ponto)begin
		case(end_ponto)
			0:begin
				ptx_r <= 84;
				pty_r <= 72;
			end
			1:begin
				ptx_r <= 23;
				pty_r <= 79;
			end
			2:begin
				ptx_r <= 48;
				pty_r <= 62;
			end
			3:begin
				ptx_r <= 46;
				pty_r <= 56;
			end
			4:begin
				ptx_r <= 08;
				pty_r <= 13;
			end
			5:begin
				ptx_r <= 200;
				pty_r <= 134;
			end

		endcase
	end
endmodule
module controle;
	
	reg clk = 0;

	reg [11:0]ptx;
	reg [11:0]pty;
	reg [11:0]p1x;
	reg [11:0]p1y;
	reg [11:0]p2x;
	reg [11:0]p2y;
	reg [11:0]p3x;
	reg [11:0]p3y;	
	
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
	reg [4:0]end_ponto = 0;
	wire P1, P2, P3;
	reg saida;
	
	sign Pt1(ptx, pty, p1x, p1y, p2x, p2y, P1);
	sign Pt2(ptx, pty, p2x, p2y, p3x, p3y, P2);
	sign Pt3(ptx, pty, p3x, p3y, p1x, p1y, P3);
	ROM R(end_triangulo, end_ponto, p1x_w, p1y_w, p2x_w, p2y_w, p3x_w, p3y_w, ptx_w, pty_w);

	always #1 clk = ~clk;
	always @(count)begin
		case(count)
			0:begin
				end_triangulo <= 0;
				count <= count + 1;
			end
			1: begin
				p1x <= p1x_w;
				p1y <= p1y_w;
				p2x <= p2x_w;
				p2y <= p2y_w;
				p3x <= p3x_w;
				p3y <= p3y_w;	
				count <= count + 1;
				end_ponto <= 0;
			end
			2: begin
				ptx <= ptx_w;
				pty <= pty_w;
				count <= count + 1;
			end
			3: begin
				end_ponto <= end_ponto + 1;
				saida <= P1 == P2 & P2 == P3;
				count <= count + 1;
			end
			4:begin
				$display("Saida : %d", saida);	
				if (end_ponto == 5)begin
					end_ponto <= 0;
					count <= 1;
					end_triangulo <= end_triangulo + 1;
					if (end_triangulo > 2)count <= 5;
				end
				else begin
					count <= 2;
				end
			end
			5: $finish;
		endcase
	end	
	initial begin

	end
endmodule
