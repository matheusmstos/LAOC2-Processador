module ALU
	(	input [15:0] A,
		input [15:0] b,
		input [3:0] op,
		output reg [15:0] result
	);

		parameter add  = 4'b0101; //5
		parameter sub  = 4'b0110;	//6
		parameter andd = 4'b0111;	//7
		parameter slt  = 4'b1000; //8: set less than
		parameter sll  = 4'b1001;	//9: shift logic left
		parameter slr  = 4'b1010; //10:shift logic right

		always @(A or b or op) begin
			case(op)
				add: result = A + b;
				sub: result = A - b;
				slt: if(A < b)result = 16'b1; else result = 16'b0;
				sll: result = A << b;
				slr: result = A >> b;
				andd:result = A & b;
			endcase
		end

endmodule
