module Unidade_Controle
	(	input Run, Resetn, clock,
		input [2:0] Counter,
		input	Xreg, Yreg,
		input [9:0] IRout,
		
		output reg IRin, Gout, DINout, Ain, Gin, AddSub,
		output reg [7:0] Rin,
		output reg [7:0] Rout,
		output reg Clear, Done, Acress

	);

	parameter add  = 4'b0000; //soma
	parameter sub  = 4'b0001; //sub
	parameter slt  = 4'b0010; //set less then
	parameter sll  = 4'b0011; //shift logic left
	parameter slr  = 4'b0100; //shift logic right
	parameter endi = 4'b0101; //and(&)
	parameter mv   = 4'b0111;
	parameter mvi  = 4'b1000;
	
	always @(Counter or IRout or Xreg or Yreg)
	begin
		
		IRin    = 1'b0;
		Gout    = 1'b0;
		DINout  = 1'b0;
		Ain     = 1'b0;
		Gin     = 1'b0;
		Rout    = 8'b0;
		Done    = 1'b0;
		
		case (Counter) 
			
			3'b000: begin
				IRin = 1'b1;
			end
			
			3'b001: begin // store DIN in IR in time step 0
				case(IRout) 
					add, sub, sll, slt, slr, endi: begin
						Rout = Xreg;
						Ain = 1'b1;
					end
					
					mv: begin
						Rout = Yreg;
						Rin = Xreg;
						Done = 1'b1;
					end
					
					mvi: begin
						DINout = 1'b1;
						Rin = Xreg;
						Done = 1'b1;
					end
				endcase
			end
			
			3'b010: begin //define signals in time step 1
				case(IRout) 
					add, sll, slt, slr, endi: begin
						Rout = Yreg;
						Gin = 1'b1;
					end
					
					sub: begin
						Rout = Yreg;
						Gin = 1'b1;
						AddSub = 1'b1;
					end
					
				endcase
			end
			
			3'b011: begin //define signals in time step 2
				case(IRout) 
					add, sub, sll, slt, slr, endi: begin
						Rin = Xreg;
						Gout = 1'b1;
						Done = 1'b1;
					end
					
				endcase
			end
		endcase
		
	end
endmodule
