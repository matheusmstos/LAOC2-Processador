 module Multiplexador
 ( input [15:0] R0, R1, R2, R3, R4, R5, R6, R7, DIN, G,
	 input [7:0] selectR,
	 input selectG, selectDin,
		
	 output reg [15:0] saida
	 );

		always @ (selectG or selectDin or selectR) begin
			if (selectG) saida = selectG;
			else if (selectDin) saida = selectDin;
			else begin
				case(selectR)
					8'b00000000: saida = R0;
					8'b00000001: saida = R1;
					8'b00000010: saida = R2;
					8'b00000011: saida = R3;
					8'b00000100: saida = R4;
					8'b00000101: saida = R5;
					8'b00000110: saida = R6;
					8'b00000111: saida = R7;
				endcase
			end
		end
endmodule