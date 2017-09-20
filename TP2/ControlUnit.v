module Unidade_Controle
	(	parameter n = 16;
		input Run, Resetn, clock, Counter
		input [9:0] IRin,

		output Done, Clear
		output reg [n-1:0] R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, Ain, Gin;
		output reg [7:0]Rout,
		output reg Gin, Ain, DINout, Gout, IRin,

	);



endmodule
