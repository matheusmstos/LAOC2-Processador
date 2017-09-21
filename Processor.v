module Processador
	(
		input [15:0] DIN,
		input Resetn, Clock, Run,
		
		output  Done, 
		output [15:0]BusWires
	);
	
	
	wire Clear;
	//wire Done;
	
	wire [2:0] opcode;
	wire [7:0] Xreg, Yreg;
	wire [8:0] IR;
	assign opcode = IR[8:6]; //quais os bits sao o upcode?
	
	//Unidade de Controle
	wire IRin, Gout, DINout, Ain, Gin, AddSub, Acress;
	wire [7:0] Rin;
	wire [7:0] Rout;
	
	//Registradores
	wire [15:0] A, G, alu_result;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	
	upcount Tstep(Clear, Clock, Tstep_Q);
	Unidade_Controle u1 (Run, Resetn, Clock, Tstep_Q, Xreg, Yreg, opcode, IRin, Gout, DINout, Ain, Gin, AddSub, Rin, Rout, Clear, Done, Acress);
	ALU alu(A, BussWires, opcode, alu_result);
	Multiplexador mux(R0, R1, R2, R3, R4, R5, R6, R7, DIN, G, Rout, Gout, DINout, BusWires);
	
	dec3to8 dc1(IR[2:0], 1'b1, Xreg);
	dec3to8 dc2(IR[5:3], 1'b1, Yreg);
	
	regn reg_0 (BusWires, Rin[0], Clock, R0);
	regn reg_1 (BusWires, Rin[1], Clock, R1);
	regn reg_2 (BusWires, Rin[2], Clock, R2);
	regn reg_3 (BusWires, Rin[3], Clock, R3);
	regn reg_4 (BusWires, Rin[4], Clock, R4);
	regn reg_5 (BusWires, Rin[5], Clock, R5);
	regn reg_6 (BusWires, Rin[6], Clock, R6);
	regc reg_7 (BusWires, Rin[7], Clock, Clear, Acress, R7);
	
	regn reg_A (BusWires, Ain, Clock, A);
	regn reg_G (alu_result, Gin, Clock, G);
	regi reg_i (DIN[8:0], IRin, Clock, IR);
	

endmodule

module Processor(KEY[3], KEY[2],SW ,LEDG, HEX0 , HEX1 , LEDR);

	input [3:0]KEY;
	input [17:0] SW;
	output [0:6]HEX0,HEX1;
	output [8:0]LEDG;
	output [15:0] LEDR;
	wire [15:0] BusWires;
	wire [15:0] DIN;
	wire [15:0]adressout;
	wire [15:0] R0, saida;

	Processador p(LEDR, SW[16], KEY[3], SW[17], BusWires);
	ramlpm  r(LEDG[7:3],  KEY[3], LEDR);

	display d1( saida[3:0], HEX0);
	display d2( saida[7:4], HEX1);
	display d3( R0[3:0], HEX2);


endmodule