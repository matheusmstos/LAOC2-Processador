module Unidade_Controle
	(	input Run, Resetn, clock,
		input [2:0] Counter,
		input	Xreg, Yreg,
		input [9:0] IRout,

		output reg IRin, Gout, DINout, Ain, Gin, AddSub,
		output reg [7;0] Rin,
		output reg [7:0] Rout,
		output reg Clear, Done, Acress

	);

	parameter add  = 3'b000; //soma
	parameter sub  = 3'b001; //sub
	parameter slt  = 3'b010; //set less then
	parameter sll  = 3'b011; //shift logic left
	parameter slr  = 3'b100; //shift logic right
	parameter endi = 3'b101; //and(&)

	always @(Tstep_Q or I or Xreg or Yreg)
	begin

		IRin    = 1'b0;
		Gout    = 1'b0;
		DINout  = 1'b0;
		Ain     = 1'b0;
		Gin     = 1'b0;
		Rout    = 8'b0;
		Done    = 1'b0;

		case (Tstep_Q)

			3'b000: begin
				IRin = 1'b1;
			end

			3'b001: begin // store DIN in IR in time step 0
				case(I)
					add, sub, sll, slt, slr, endi: begin
						Rout = xreg;
						Ain = 1'b1;
					end

					mv: begin
						Rout = yreg;
						Rin = xreg;
						Done = 1'b1;
					end

					mvi: begin
						DINout = 1'b1;
						Rin = xreg;
						Done = 1'b1;
					end
				endcase
			end

			3'b010: begin //define signals in time step 1
				case(I)
					add, sll, slt, slr, endi: begin
						Rout = yreg;
						Gin = 1'b1;
					end

					sub: begin
						Rout = yreg;
						Gin = 1'b1;
						AddSub = 1'b1;
					end

				endcase
			end

			3'b011: begin //define signals in time step 2
				case(I)
					add, sub, sll, slt, slr, endi: begin
						Rin = xreg;
						Gout = 1'b1;
						Done = 1'b1;
					end

				endcase
			end

endmodule
