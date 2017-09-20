module dec3to8
  (
    input [2:0] W;
    input En;
    output reg [7:0] Y;
  );

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
