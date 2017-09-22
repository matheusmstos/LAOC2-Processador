module Processador
	(
		input [15:0] DIN,
		input Resetn, Clock, Run,
		output reg Done,
		output [15:0]BusWires,

		output [15:0] Adress_out,
		output [15:0] DOUT,
		output reg Enable_escrita_mem,
		output [2:0] Ciclo
	);

	reg [7:0] R_in, R_out;
	reg IR_in, Adress_in, A_in, G_in, G_out, DIN_out, Acressimo, DOUT_in;

	wire [9:0] IR;
	wire [3:0] opcode;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G, ALU_result;
	wire [7:0] Xreg, Yreg;
	wire Clear = Done | Resetn;

 //Unidade de Controle --------------------------------------------------------
	assign opcode = IR[9:6];
	dec3to8 dc1 (IR[5:3], 1'b1, Xreg);
	dec3to8 dc2 (IR[2:0], 1'b1, Yreg);
	upcount Counter (Clear, Clock, Ciclo);

	parameter ld   = 4'b0000;
	parameter st   = 4'b0001;
	parameter mvnz = 4'b0010;
	parameter mv   = 4'b0011;
	parameter mvi  = 4'b0100;

	parameter add  = 4'b0101;
	parameter sub  = 4'b0110;
	parameter andd = 4'b0111;
	parameter slt  = 4'b1000;
	parameter sll  = 4'b1001;
	parameter slr  = 4'b1010;

	always @(Ciclo or opcode or Xreg or Yreg) begin

		R_out      = 8'b0;
		R_in       = 8'b0;
		IR_in      = 1'b0;
		Done       = 1'b0;
		A_in       = 1'b0;
		G_in       = 1'b0;
		G_out      = 1'b0;
		Acressimo	     = 1'b0;
		DIN_out    = 1'b0;
		Adress_in = 1'b0;
		Enable_escrita_mem = 1'b0;

		case (Ciclo)

			3'b000: begin		//Time Step 0 -> Pega a primeira
				R_out      = 8'b10000000;
				Adress_in = 1'b1;
			end

			3'b011: begin		//Time Step 3
				IR_in = 1'b1;
				Acressimo = 1'b1;
			end

			3'b100: begin //Time Step 4
				case (opcode)

					ld: begin
						Adress_in = 1'b1;
						R_out = Yreg;
					end

					st: begin
						Adress_in = 1'b1;
						R_out = Yreg;
					end

					mvnz: begin
						if(G != 0)
						R_in = Xreg;
						R_out = Yreg;
						Done = 1'b1;
					end

					mv: begin
						R_in = Xreg;
						R_out = Yreg;
						Done = 1'b1;
					end

					mvi: begin
						R_out     = 8'b10000000;
						Adress_in = 1'b1;
					end

					add,sub,andd,slt,sll,slr: begin
						R_out = Xreg;
						A_in = 1'b1;
					end

				endcase
			end

			3'b101: begin	//Time Step 5
				case(opcode)
					ld: begin
						//Delay Time
					end

					st: begin
						R_out = Xreg;
					end

					mvi: begin
						//Delay Time
					end

					add,sub,andd,slt,sll,slr: begin
						G_in = 1'b1;
						R_out = Yreg;
					end
				endcase
			end

			3'b110: begin	//Time Step 6
				case (opcode)

					ld: begin
						//Delay Time
					end

					st: begin
						Enable_escrita_mem = 1'b1;
						Done = 1'b1;
					end

					mvi: begin
						//Delay Time
					end

					add,sub,andd,slt,sll,slr: begin
						G_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
					end

				endcase
			end

			3'b111: begin	//Time Step 7
				case (opcode)

					ld: begin
						DIN_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
					end

					mvi: begin
						DIN_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
						Acressimo = 1'b1;
					end

				endcase
			end

		endcase
	end

	//Instancia a galera --------------------------------------------------------

	regn reg_0 (BusWires, R_in[0], Clock, R0);
	regn reg_1 (BusWires, R_in[1], Clock, R1);
	regn reg_2 (BusWires, R_in[2], Clock, R2);
	regn reg_3 (BusWires, R_in[3], Clock, R3);
	regn reg_4 (BusWires, R_in[4], Clock, R4);
	regn reg_5 (BusWires, R_in[5], Clock, R5);
	regn reg_6 (BusWires, R_in[6], Clock, R6);
	regc reg_7 (BusWires, R_in[7], Clock, Resetn, Acressimo, R7);

	regn reg_A (BusWires, A_in, Clock, A);
	regn reg_G (ALU_result, G_in, Clock, G);
	regi reg_i (DIN[9:0], IR_in, Clock, IR);
	regn ADOut (BusWires, Adress_in, Clock, Adress_out);
	regn DOUTn	 (BusWires, Done, Clock, DOUT);

	ALU alu (A, BusWires, opcode, ALU_result);
	Multiplexador mux(R0,R1,R2,R3,R4,R5,R6,R7,DIN,G,R_out,G_out,DIN_out,BusWires);

endmodule

module Processor(SW,KEY,LEDR,LEDG,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
	input [17:0]SW;
	input [3:0]KEY;
	output [17:0]LEDR;
	output [8:0]LEDG;
	output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

	//Wires
	wire [15:0]BusWires;
	wire [15:0]DIN;
	wire [15:0]AddressOut;					//Display
	wire [15:0]DOUT;							//Display
	wire [15:0]MemOut;
	wire Escrita;
	wire Done;
	wire Run;
	wire [2:0]Ciclo;

	//Processador proc(MemOut,KEY[3],SW[16],SW[17],Done,Escrita,AddressOut,BusWires,DOUT,Ciclo);
	Processador proc (MemOut,SW[16],KEY[3],SW[17],Done, BusWires,AddressOut,DOUT,Escrita,Ciclo);
	ramlpm mem(AddressOut[4:0],KEY[3],DOUT,Escrita,MemOut);

	assign LEDR[15:0] = BusWires[15:0];
	assign LEDG[0] = Escrita;
	assign LEDG[8] = Done;

	/*
		RelaÃ§Ãµes de Sinal

			SW  17 - Run
			KEY  3 - Clock
			KEY  2 - Resetn

			Done = LEDG 8
			Write = LEDG 0
			AddressOut = LEDR[15:0]

			Display 0 a 3 -> DIN
			Display 4  -> EndereÃ§o da MemÃ³ria AddressOut[4:0];

			Display 5 -> DOUT
			Display 6 -> DOUT
			Display 7 -> DOUT
			Display 8 -> DOUT
	*/

	Display d7 (BusWires[15:12]  ,HEX7);
	Display d6 ({1'b0,Ciclo[2:0]}  ,HEX6);
	Display d5 (AddressOut[7:4]    ,HEX5);
	Display d4 (AddressOut[3:0]    ,HEX4);

	Display d3 (MemOut[15:12],HEX3);
	Display d2 (MemOut[11:8] ,HEX2);
	Display d1 (MemOut[7:4]  ,HEX1);
	Display d0 (MemOut[3:0]  ,HEX0);

endmodule
