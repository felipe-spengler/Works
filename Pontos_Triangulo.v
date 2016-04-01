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
module triangulo(
  input [11:0] ptx,
  input [11:0] pty,
  input [11:0] p1x,
  input [11:0] p1y,
  input [11:0] p2x,
  input [11:0] p2y,
  input [11:0] p3x,
  input [11:0] p3y,
  output saida
);


wire P1, P2, P3;

sign Pt1(ptx, pty, p1x, p1y, p2x, p2y, P1);
sign Pt2(ptx, pty, p2x, p2y, p3x, p3y, P2);
sign Pt3(ptx, pty, p3x, p3y, p1x, p1y, P3);

assign saida = P1 == P2 & P2 == P3;

endmodule

module executa;

integer data_file;
integer write_file;
integer valor;

reg signed [11:0] ptx;
reg signed [11:0] pty;
reg signed [11:0] p1x;
reg signed [11:0] p1y;
reg signed [11:0] p2x;
reg signed [11:0] p2y;
reg signed [11:0] p3x;
reg signed [11:0] p3y;
wire saida;
reg state = 0;
triangulo T(ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y, saida);

initial begin
  data_file = $fopen("entradas.txt", "r");
  write_file = $fopen("saidas_verilog.txt", "w");
  if (data_file == 0) begin
    $display("ERRO!! Nao foi possivel abrir arquivo");
    $finish;
  end else begin
    $display("Arquivo foi aberto!");
  end
  if (write_file == 0) begin
    $display("ERRO!! Nao foi possivel abrir arquivo escrita");
    $finish;
  end else begin
    $display("Arquivo 2 foi aberto!");
  end
end

always #2 begin
  if (!$feof(data_file)) begin
	  if (state != 0)begin

	    $fdisplay(write_file, "%d%d %d %d %d %d %d %d = %d",
	      ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y, saida);

	    valor = $fscanf(data_file, "%d %d %d %d %d %d %d %d\n",
	      ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y);
	  end else begin
		valor = $fscanf(data_file, "%d %d %d %d %d %d %d %d\n",
	      ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y);
		state = 1;
  	end
  end
  else begin
    $finish;
  end
end

endmodule
