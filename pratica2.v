module pratica2(KEY[3], KEY[2],SW ,LEDG, HEX0 , HEX1 , LEDR);
input [3:0]KEY;
input [17:0] SW;
output [0:6]HEX0,HEX1;
output [8:0]LEDG;
output [15:0] LEDR;
wire [15:0] BusWires;
wire [15:0] DIN;
wire [15:0]adressout;
wire [15:0] R0, saida;

proc p(LEDR, SW[16], KEY[3], SW[17], LEDG [8], BusWires , LEDG[7:3],LEDG[2:0] ,R0, saida);
romlpm  r(LEDG[7:3],  KEY[3], LEDR);

display d1( saida[3:0], HEX0);
display d2( saida[7:4], HEX1);
display d3( R0[3:0], HEX2);


endmodule

module display (Entrada, SaidaDisplay);
  input [3:0] Entrada;
  output reg [0:6] SaidaDisplay;

  //Decodificador Display de 7 segmentos
  always begin
    case(Entrada)

      0:SaidaDisplay=7'b0000001; //0
      1:SaidaDisplay=7'b1001111; //1
      2:SaidaDisplay=7'b0010010; //2
      3:SaidaDisplay=7'b0000110; //3
      4:SaidaDisplay=7'b1001100; //4
      5:SaidaDisplay=7'b0100100; //5
      6:SaidaDisplay=7'b0100000; //6
      7:SaidaDisplay=7'b0001111; //7
      8:SaidaDisplay=7'b0000000; //8
      9:SaidaDisplay=7'b0001100; //9
      10:SaidaDisplay=7'b0001000;//A
      11:SaidaDisplay=7'b1100000;//B
      12:SaidaDisplay=7'b0110001;//C
      13:SaidaDisplay=7'b1000010;//D
      14:SaidaDisplay=7'b0110000;//E
      15:SaidaDisplay=7'b0111000;//F
    endcase
  end
endmodule

module proc (DIN, Resetn, Clock, Run, Done, BusWires, adressout,Tstep_Q ,R0, saida);
	input [15:0] DIN;
	input Resetn, Clock, Run;

	output Done;
	output [15:0] BusWires, adressout ,R0, saida;
	reg [7:0] Rin, Rout;
	reg IRin, adressin, Ain, Gin, Gout, DINout, acress, Done;


	wire [7:0] Xreg, Yreg;
	wire [9:1] IR;
	output [2:0]Tstep_Q;
	wire [15:0]  R1, R2, R3, R4, R5, R6, R7, A, G, result;
	wire [2:0]I;

	// instruções a serem utilizadas no processador
	parameter mv  = 3'b000;
	parameter sub = 3'b001;
	parameter add = 3'b010;
	parameter mvi = 3'b011;
	parameter orr = 3'b100;
	parameter slt = 3'b101;
	parameter sll = 3'b110;
	parameter slr = 3'b111;

	wire Clear = Done | Resetn;

	//Unidade de controle---------------------------
	upcount Tstep (Clear, Clock & Run, Tstep_Q);
	assign I = IR[9:7];
	dec3to8 decX (IR[6:4], 1'b1, Xreg);
	dec3to8 decY (IR[3:1], 1'b1, Yreg);

	always @(Tstep_Q or I or Xreg or Yreg)
	begin

		Rout    = 8'b0;
		Rin     = 8'b0;
		IRin    = 1'b0;
		Done    = 1'b0;
		Ain     = 1'b0;
		Gin     = 1'b0;
		Gout    = 1'b0;
		acress  = 1'b0;
		DINout  = 1'b0;
		adressin = 1'b0;


		case (Tstep_Q)

			3'b000: // store DIN in IR in time step 0
			begin
				Rout = 8'b10000000;
				adressin = 1'b1;
			end

			3'b001: //define signals in time step 1
			;

			3'b010: //define signals in time step 2
			;

			3'b011: //define signals in time step 3
			begin
				IRin = 1'b1;
				acress = 1'b1;
			end

			3'b100: //define signals in time step 4
				case (I)
					add, sub, orr, slt, sll, slr:
					begin
						Rout = Xreg;
						Ain  = 1'b1;
					end

					mv:
					begin
						Rout = Yreg;
						Rin  = Xreg;
						Done = 1'b1;
					end

					mvi:
					begin
						Rout = 8'b10000000;
						adressin = 1'b1;
					end
				endcase



			3'b101: //define signals in time step 5
				case (I)
					add, sub, orr, slt, sll, slr:
					begin
						Rout = Yreg;
						Gin  = 1'b1;
					end
				endcase

			3'b110: //define signals in time step 6
				case (I)
					add, sub, orr, slt, sll, slr:
					begin
						Rin = Xreg;
						Gout = 1'b1;
						Done = 1'b1;
					end
				endcase
			3'b111: //define signals in time step 6
				case(I)
					mvi:
					begin
						DINout = 1'b1;
						Rin = Xreg;
						acress = 1'b1;
						Done = 1'b1;
					end
				endcase
		endcase
	end


//Declarações------------------------------------
regn reg_0 (BusWires, Rin[0], Clock, R0);
regn reg_1 (BusWires, Rin[1], Clock, R1);
regn reg_2 (BusWires, Rin[2], Clock, R2);
regn reg_3 (BusWires, Rin[3], Clock, R3);
regn reg_4 (BusWires, Rin[4], Clock, R4);
regn reg_5 (BusWires, Rin[5], Clock, R5);
regn reg_6 (BusWires, Rin[6], Clock, R6);
regc reg_7 (BusWires, Rin[7], Resetn, Clock, R7, acress);

regn reg_A (BusWires, Ain, Clock, A);
regn reg_G (result, Gin, Clock, G);
regi reg_i (DIN, IRin, Clock, IR);
regn adress (BusWires, adressin, Clock, adressout);
ULA u (A, BusWires, I, result);
mux m (R0, R1, R2, R3, R4, R5, R6, R7, DIN, G, Rout, DINout, Gout, BusWires);
regn s (BusWires, Done, Clock, saida);

endmodule


module upcount(Clear, Clock, Q);
	input Clear, Clock;
	output [2:0] Q;
	reg [2:0] Q;
	initial Q = 3'b0;
	always @(posedge Clock)
		if (Clear)
			Q <= 3'b0;
		else
			Q <= Q + 1'b1;
endmodule

//conversosr-----------------------------------
module dec3to8(W, En, Y);
	input [2:0] W;
	input En;
	output [7:0] Y;
	reg [7:0] Y;

	always @(W or En)
	begin
		if (En == 1)
			case (W)
				3'b000: Y = 8'b00000001;
				3'b001: Y = 8'b00000010;
				3'b010: Y = 8'b00000100;
				3'b011: Y = 8'b00001000;
				3'b100: Y = 8'b00010000;
				3'b101: Y = 8'b00100000;
				3'b110: Y = 8'b01000000;
				3'b111: Y = 8'b10000000;
			endcase
		else
			Y = 8'b00000000;
	end
endmodule

//Módulo dos registradores
module regn(R, Rin, Clock, Q);
	parameter n = 16;
	input [n-1:0] R;
	input Rin, Clock;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	initial
	Q = 16'b10;
	always @(posedge Clock)
		if (Rin)
			Q <= R;
endmodule


module regi(R, Rin, Clock, Q);
	parameter n = 9;
	input [n-1:0] R;
	input Rin, Clock;
	output [n-1:0] Q;
	reg [n-1:0] Q;

	always @(posedge Clock)
		if (Rin)
			Q <= R;
endmodule

//contador
module regc(R, Rin, clear,Clock, Q, acress);
	parameter n = 16;
	input [n-1:0] R;
	input Rin, Clock, acress, clear;
	output [n-1:0] Q;
	reg [n-1:0] Q;

	initial Q = 16'b0 ;
	always @(posedge Clock)
		if (Rin)
			Q <= R;
		else if(acress) Q = Q + 1'b1;
		else if(clear) Q = 16'b0;
endmodule

//Unidade Lógica e aritmética
module ULA(a, b, op, result);
input [15:0] a, b;
input [2:0] op;
output reg [15:0] result;

// instruções a serem utilizadas no processador
	parameter sub = 3'b001;
	parameter add = 3'b010;
	parameter orr = 3'b100;
	parameter slt = 3'b101;
	parameter sll = 3'b110;
	parameter slr = 3'b111;

	always @(a or b or op)
	begin
		case(op)
			add: result = a + b;
			sub: result = a - b;
			orr: result = a | b;
			sll: result = a << b;
			slr: result = a >> b;
			slt: if(a < b)result = 16'b1; else result = 16'b0;

		endcase
	end
endmodule

//Multiplexador
module mux(R0, R1, R2, R3, R4, R5, R6, R7, DIN, G, selR, selDIN, selG, saida);
output reg [15:0] saida;
input [15:0] R0, R1, R2, R3, R4, R5, R6, R7, DIN, G;
input [7:0] selR;
input selDIN, selG;

	always @(selDIN or selG or selR)
	begin
		if(selDIN) saida = DIN;
			else if(selG) saida = G;
				else begin
					case(selR)
						8'b00000001: saida = R0;
						8'b00000010: saida = R1;
						8'b00000100: saida = R2;
						8'b00001000: saida = R3;
						8'b00010000: saida = R4;
						8'b00100000: saida = R5;
						8'b01000000: saida = R6;
						8'b10000000: saida = R7;
					endcase
				end
	end
endmodule
