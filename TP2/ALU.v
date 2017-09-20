module ALU
	( parameter n = 16;
		input [n-1:0] A,
		input [n-1:0] b,
		input [3:0] op;
		input Addsub, //vem do controlador

		output reg [n-1:0] result,
		);

		parameter add  = 4'b0000; //soma
		parameter sub  = 4'b0001;	//sub
		parameter slt  = 4'b0010;	//set less then
		parameter sll  = 4'b0011; //shift logic left
		parameter slr  = 4'b0100;	//shift logic right
		parameter endi = 4'b0101; //and(&)

		always @(A or b or op) begin
			case(op)
				add: result = A + b;
				sub: result = A - b;
				slt: if(A < b)result = 16'b1; else result = 16'b0;
				sll: A << b;
				slr: A >> b;
				endi: A & b;
			endcase
		end

endmodule
