module Reg1
	( input [15:0] R,
		input Rin, //vem do controlador
		input clock,
		output reg [n-1:0] Q
	);

	initial begin
		Q = 16'b10;
	end

	always @(posedge Clock) begin
		if (Rin)
			Q <= R;
	end
endmodule //Registradores

module Reg2
	( input [15:0] R,
		input Rin, //vem do controlador
		input clock,
		output reg [n-1:0] Q
	);

	always @(posedge Clock) begin
		if (Rin)
			Q <= R;
	end
endmodule //Registradores
