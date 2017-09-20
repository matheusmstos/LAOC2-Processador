module Registradores
	( parameter n = 16,
		input [n-1:0] R,
		input Rin, //vem do controlador
		input clock,
		output reg [n-1:0] Q
	);

	initial begin
		Q = 16'b0;
	end

	always @(posedge Clock) begin
		if (Rin)
			Q <= R;
	end
endmodule //Registradores
