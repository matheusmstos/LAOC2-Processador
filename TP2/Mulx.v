 module Multiplexador
 ( input [15:0] R0, R1, R2, R3, R4, R5, R6, R7, DIN, G,
	 input [7:0] selectR,
	 input selectG, selectDin,

	 output reg [15:0] MUXOut
	 );

		always @ (selectG or selectDin or selectR) begin
			if (selectG) MUXOut = selectG;
			else if (selectDin) MUXOut = selectDin;
			else begin
				case(selectR)
					8'b00000000: MUXOut = R0; //R0:0
					8'b00000001: MUXOut = R1; //R1:1
					8'b00000010: MUXOut = R2; //R2:2
					8'b00000011: MUXOut = R3; //R3:3
					8'b00000100: MUXOut = R4; //R4:4
					8'b00000101: MUXOut = R5; //R5:5
					8'b00000110: MUXOut = R6; //R6:6
					8'b00000111: MUXOut = R7; //R7:7
				endcase
			end
		end
endmodule
