module Unidade_Controle
	(	input Run, Resetn, clock,
		input [2:0] Counter,
		input	[7:0] Xreg, Yreg,
		input [2:0] IRout,
		
		output reg IRin, Gout, DINout, Ain, Gin, AddSub,
		output reg [7:0] Rin,
		output reg [7:0] Rout,
		output reg Clear, Done, Acress

	);

	parameter add  = 3'b000; //soma
	parameter sub  = 3'b001; //sub
	parameter slt  = 3'b010; //set less then
	parameter sll  = 3'b011; //shift logic left
	parameter slr  = 3'b100; //shift logic right
	parameter endi = 3'b101; //and(&)
	parameter mv   = 3'b110;
	parameter mvi  = 3'b111;
	
	always @(
	Counter or IRout or Xreg or Yreg)
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
				Acress = 1'b1;
			end
			
			3'b011: begin // store DIN in IR in time step 0
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
			
			3'b100: begin //define signals in time step 1
				case(IRout) 
					add, sub, sll, slt, slr, endi: begin
						Rout = Yreg;
						Gin = 1'b1;
					end
									
				endcase
			end
			
			3'b101: begin //define signals in time step 2
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
