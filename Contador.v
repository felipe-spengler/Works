module Itens(
	input [5:0]fio,
	input luz,
	output cont1
);

   assign cont1 = fio;

endmodule
module test;

reg [5:0]fio;
reg luz;
wire cont1;

Itens I(fio, luz, cont1);
always #1
begin
	fio = fio + 1;
	if (fio == 6'b111111)begin
		case(luz) 
			1: luz = 0;
			0: luz = 1;
		endcase
		fio <= 6'b0;
		end

	
end
	initial begin
	$dumpvars (0,I);
	#0;
	fio <= 6'b0;
	luz <= 1'b0;
	#2000
	$finish;
	end
endmodule
