//============================================
//
// SubByte Module used in Rounds
//
//============================================


module sub_byte(	clk, rst, en, 
					sb_in0, sb_in1, sb_in2, sb_in3,
					sub_flag,
					b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15,
					sb_en,
					sb_out0, sb_out1, sb_out2, sb_out3,
					s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
					done
				);

input clk, rst, en;
input sub_flag;
input[7:0] sb_in0, sb_in1, sb_in2, sb_in3;
input[7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
output sb_en;
output[7:0] sb_out0, sb_out1, sb_out2, sb_out3;
output[7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
output done;

//By rules all the input ports should be wires
wire clk, rst, en;
wire sub_flag;																		// Input flag from S_Box with the Subsituted Bytes, to convey that the bytes are substituted.
wire[7:0] sb_in0, sb_in1, sb_in2, sb_in3;											// Input from S_Box
wire[7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;		// Input from AddRounKey

//Output ports could be storage elements (regs) or wires
reg sb_en;																			// To enable (rd_en) S_Box before sending the address for substitution of bytes
reg[7:0] sb_out0, sb_out1, sb_out2, sb_out3;										// Output to S_Box (addr)
reg[7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;		// Output to ShiftRows
reg done;																			// done signal to controller
//reg[3:0] upper_nibble, lower_nibble;

integer i=1;
integer j=1;

always @ (posedge clk)
begin: substitute

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
		sb_en   <= 1'b0;		// rd_en = 0
		sb_out0 <= 8'h00;		// all addr = 0
		sb_out1 <= 8'h00;
		sb_out2 <= 8'h00;
		sb_out3 <= 8'h00;
		i=1;
		j=1;
		done=0;
	end
	
	//When data available rom AddRoundKey
	else if(en==1'b1) begin
	
		if(i==1) begin			//Ask S-Box for substitution of 4Bytes of Coloumn-1
		sb_en = 1;
		done=0;
		sb_out0 = b0;
		sb_out1 = b1;
		sb_out2 = b2;
		sb_out3 = b3;
		end
		
		else if(i==2) begin		//Ask S-Box for substitution of 4Bytes of Coloumn-2
		sb_out0 = b4;
		sb_out1 = b5;
		sb_out2 = b6;
		sb_out3 = b7;		
		end
		
		else if(i==3) begin		//Ask S-Box for substitution of 4Bytes of Coloumn-3
		sb_out0 = b8;
		sb_out1 = b9;
		sb_out2 = b10;
		sb_out3 = b11;
		end
		
		else if(i==4) begin		//Ask S-Box for substitution of 4Bytes of Coloumn-4
		sb_out0 = b12;
		sb_out1 = b13;
		sb_out2 = b14;
		sb_out3 = b15;
		i=0;
		end
		
		i=i+1;
		
		if(sub_flag==1'b1) begin	// if done=1 from s_box (Reading from S_Box)
	
			if(j==1) begin			//substitution of 4Bytes of Coloumn-1
			s0 = sb_in0;
			s1 = sb_in1;
			s2 = sb_in2;
			s3 = sb_in3;
//			negedge(clk) sub_flag=0;
			end
			
			else if(j==2) begin		//substitution of 4Bytes of Coloumn-2
			s4 = sb_in0;
			s5 = sb_in1;
			s6 = sb_in2;
			s7 = sb_in3;		
			end
			
			else if(j==3) begin		//substitution of 4Bytes of Coloumn-3
			s8 = sb_in0;
			s9 = sb_in1;
			s10 = sb_in2;
			s11 = sb_in3;
			end
			
			else if(j==4) begin		//substitution of 4Bytes of Coloumn-4
			s12 = sb_in0;
			s13 = sb_in1;
			s14 = sb_in2;
			s15 = sb_in3;
//			sb_en = 0;
			j=0;
			done=1;
			end
		
		j=j+1;
		end
		
	end
	
end		//End of Block sub_out

endmodule