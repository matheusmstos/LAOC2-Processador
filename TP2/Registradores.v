module regn
	( input [15:0] R,	//valor
		input Rin, Clock 			//vem do controlador
		output reg [15:0] Q
	);

	initial begin
		Q = 16'b10;
	end

	always @(posedge Clock) begin
		if (Rin)
			Q <= R;
	end
endmodule

module regi
	( input [9:0] R,
		input Rin, Clock,
		output reg [9:0] Q
	);

	always @(posedge Clock) begin
		if (Rin)
			Q <= R;
	end
endmodule

module regc //o registrador 7 eh um contador de intrucoes, o famoso ponteiro de intructions
	(	input [15:0] R,
		input Rin, Clock, Clear, Prox,
		output reg [15:0] Q
	);

	initial Q = 16'b0 ;
	always @(posedge Clock) begin
		if (Rin)
			Q <= R;
		else if(Prox) Q = Q + 1'b1;
		else if(Clear) Q = 16'b0;
	end
endmodule
