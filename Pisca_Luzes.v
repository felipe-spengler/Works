module Contador(
	input CLOCK_50,
	output [7:0]LEDG);

reg [32:0]cont;
reg state;

assign LEDG[0] = state;


always @(posedge CLOCK_50)
begin
	cont = cont + 1;
	if (cont == 50000000)begin
		case(state) 
			1: state = 0;
			0: state = 1;
		endcase
		cont <= 6'b0;
	end
end
endmodule
