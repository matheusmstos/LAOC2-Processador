module upcount
	( input Clear, Clock,
		output reg [2:0] Q
	);

	initial Q = 3'b0;
	always @(posedge Clock)
		if (Clear)
			Q <= 3'b0;
		else
			Q <= Q + 1'b1;
endmodule
