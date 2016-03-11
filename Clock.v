module Values(
    input clk,
    output saida
  );

  assign saida = clk;
  

endmodule

module test;

  reg clk;

  wire saida;

  Values V(clk, saida);
  always #10 clk = ~clk;
  
  initial begin
    $dumpvars(0, V);
    #10;
    clk <=  1'b0;
    #500;
    $finish;
  end
endmodule
