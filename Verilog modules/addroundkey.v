//============================================
//
// AddRoundKey Module used in Rounds
// sel==0: Input from MixColumn
// sel==1: Input from SubShift
//============================================

`timescale 1ns / 1ps
module addroundkey(	clk, rst, en,
					sel,
					b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15,
					sr_b0, sr_b1, sr_b2, sr_b3, sr_b4, sr_b5, sr_b6, sr_b7, sr_b8, sr_b9, sr_b10, sr_b11, sr_b12, sr_b13, sr_b14, sr_b15,
					k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14, k15,
					s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
					done
				  );

input clk, rst, en;
input sel;
input[7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
input[7:0] sr_b0, sr_b1, sr_b2, sr_b3, sr_b4, sr_b5, sr_b6, sr_b7, sr_b8, sr_b9, sr_b10, sr_b11, sr_b12, sr_b13, sr_b14, sr_b15;
input[7:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14, k15;
output[7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
output done;

//By rules all the input ports should be wires
wire clk, rst, en;
wire sel;																			// Select wether the input is from ShiftRows(sel==1) or MixColumns(sel==0)																
wire[7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;		// Input State from Plaintext or MixColumns
wire[7:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14, k15;		// Input Key-State from KeyExpansion 
wire[7:0] sr_b0, sr_b1, sr_b2, sr_b3, sr_b4, sr_b5, sr_b6, sr_b7, sr_b8, sr_b9, sr_b10, sr_b11, sr_b12, sr_b13, sr_b14, sr_b15;	// Input State from ShiftRows

//Output ports could be storage elements (regs) or wires
reg sb_en;																			// To enable S_Box before sending the address for substitution of bytes
reg[7:0] sb_out0, sb_out1, sb_out2, sb_out3;										// Output to S_Box
reg[7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;		// Output to ShiftRows
reg done;

integer i=1;
integer j=1;


always @ (posedge clk)
begin: addkey

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
	
		if(sel==0) begin	//Input state from MixColumns
			s0 = b0 ^ k0;
			s1 = b1 ^ k1;
			s2 = b2 ^ k2;
			s3 = b3 ^ k3;
			s4 = b4 ^ k4;
			s5 = b5 ^ k5;
			s6 = b6 ^ k6;
			s7 = b7 ^ k7;
			s8 = b8 ^ k8;
			s9 = b9 ^ k9;
			s10 = b10 ^ k10;
			s11 = b11 ^ k11;
			s12 = b12 ^ k12;
			s13 = b13 ^ k13;
			s14 = b14 ^ k14;
			s15 = b15 ^ k15;
			done=1;			
		end
		
		else if(sel==1) begin	//Input state from SubShift
			s0 = sr_b0 ^ k0;
			s1 = sr_b1 ^ k1;
			s2 = sr_b2 ^ k2;
			s3 = sr_b3 ^ k3;
			s4 = sr_b4 ^ k4;
			s5 = sr_b5 ^ k5;
			s6 = sr_b6 ^ k6;
			s7 = sr_b7 ^ k7;
			s8 = sr_b8 ^ k8;
			s9 = sr_b9 ^ k9;
			s10 = sr_b10 ^ k10;
			s11 = sr_b11 ^ k11;
			s12 = sr_b12 ^ k12;
			s13 = sr_b13 ^ k13;
			s14 = sr_b14 ^ k14;
			s15 = sr_b15 ^ k15;
			done=1;
		end
	end
	
	else begin
		done = 0;
	end
	
end		//End of Block addkey

endmodule