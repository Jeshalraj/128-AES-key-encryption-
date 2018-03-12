//============================================
//
// MixColumns Module used in Rounds
//
//============================================

`timescale 1ns / 1ps
module mix_columns(	clk, rst, en,
					b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15,
					s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
					done
				  );

input clk, rst, en;
input[7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
output[7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
output done;

//By rules all the input ports should be wires
wire clk, rst, en;																																	
wire[7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;		// Input State from or ShiftRows

//Output ports could be storage elements (regs) or wires
reg[7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;		// Output to AddRoundKey
reg done;

reg[7:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;		// di=2*si
integer i=1;
integer j=1;


always @ (posedge clk)
begin: mix

	if(rst==1'b1) begin
		s0 <=  8'h00;
		s1 <=  8'h00;
		s2 <=  8'h00;
		s3 <=  8'h00;
		s4 <=  8'h00;
		s5 <=  8'h00;
		s6 <=  8'h00;
		s7 <=  8'h00;
		s8 <=  8'h00;
		s9 <=  8'h00;
		s10 <= 8'h00;
		s11 <= 8'h00;
		s12 <= 8'h00;
		s13 <= 8'h00;
		s14 <= 8'h00;
		s15 <= 8'h00;
		done = 0;
	end
	
	else if(en==1'b1) begin
		
		d0 = b0 << 1;			//d0=2*b0
		if(b0[7]&1) begin
			d0 = d0 ^ 8'h1B;	//d0=2*b0, if high_bit is set
		end
		
		d1 = b1 << 1;
		if(b1[7]&1) begin
			d1 = d1 ^ 8'h1B;	
		end
		
		d2 = b2 << 1;
		if(b2[7]&1) begin
			d2 = d2 ^ 8'h1B;
		end
		
		d3 = b3 << 1;
		if(b3[7]&1) begin
			d3 = d3 ^ 8'h1B;
		end
		
		s0 = d0 ^ b3 ^ b2 ^ d1 ^ b1;	// 2*b0 + b3 + b2 + 3*b1
		s1 = d1 ^ b0 ^ b3 ^ d2 ^ b2;	// 2*b1 + b0 + b3 + 3*b2
		s2 = d2 ^ b1 ^ b0 ^ d3 ^ b3;	// 2*b2 + b1 + b0 + 3*b3
		s3 = d3 ^ b2 ^ b1 ^ d0 ^ b0;	// 2*b3 + b2 + b1 + 3*a0
		
		
		d4 = b4 << 1;
		if(b4[7]&1) begin
			d4 = d4 ^ 8'h1B;	
		end
		
		d5 = b5 << 1;
		if(b5[7]&1) begin
			d5 = d5 ^ 8'h1B;
		end
		
		d6 = b6 << 1;
		if(b6[7]&1) begin
			d6 = d6 ^ 8'h1B;
		end
		
		d7 = b7 << 1;
		if(b7[7]&1) begin
			d7 = d7 ^ 8'h1B;
		end
		
		s4 = d4 ^ b7 ^ b6 ^ d5 ^ b5;
		s5 = d5 ^ b4 ^ b7 ^ d6 ^ b6;
		s6 = d6 ^ b5 ^ b4 ^ d7 ^ b7;
		s7 = d7 ^ b6 ^ b5 ^ d4 ^ b4;
		
		
		d8 = b8 << 1;			//d0=2*b0
		if(b8[7]&1) begin
			d8 = d8 ^ 8'h1B;	//d0=2*b0, if high_bit is set
		end
		
		d9 = b9 << 1;
		if(b9[7]&1) begin
			d9 = d9 ^ 8'h1B;	
		end
		
		d10 = b10 << 1;
		if(b10[7]&1) begin
			d10 = d10 ^ 8'h1B;
		end
		
		d11 = b11 << 1;
		if(b11[7]&1) begin
			d11 = d11 ^ 8'h1B;
		end
		
		s8 = d8 ^ b11 ^ b10 ^ d9 ^ b9;		// 2*b0 + b3 + b2 + 3*b1
		s9 = d9 ^ b8 ^ b11 ^ d10 ^ b10;		// 2*b1 + b0 + b3 + 3*b2
		s10 = d10 ^ b9 ^ b8 ^ d11 ^ b11;	// 2*b2 + b1 + b0 + 3*b3
		s11 = d11 ^ b10 ^ b9 ^ d8 ^ b8;		// 2*b3 + b2 + b1 + 3*a0
		
		
		d12 = b12 << 1;			//d0=2*b0
		if(b12[7]&1) begin
			d12 = d12 ^ 8'h1B;	//d0=2*b0, if high_bit is set
		end
		
		d13 = b13 << 1;
		if(b13[7]&1) begin
			d13 = d13 ^ 8'h1B;	
		end
		
		d14 = b14 << 1;
		if(b14[7]&1) begin
			d14 = d14 ^ 8'h1B;
		end
		
		d15 = b15 << 1;
		if(b15[7]&1) begin
			d15 = d15 ^ 8'h1B;
		end
		
		s12 = d12 ^ b15 ^ b14 ^ d13 ^ b13;		// 2*b0 + b3 + b2 + 3*b1
		s13 = d13 ^ b12 ^ b15 ^ d14 ^ b14;		// 2*b1 + b0 + b3 + 3*b2
		s14 = d14 ^ b13 ^ b12 ^ d15 ^ b15;		// 2*b2 + b1 + b0 + 3*b3
		s15 = d15 ^ b14 ^ b13 ^ d12 ^ b12;		// 2*b3 + b2 + b1 + 3*a0
		
		done=1;
//		#10 done=0;
	end

	else begin
		done = 0;
	end
	
end

endmodule