`timescale 1ns /1ps
module key_ex_1(
k_in0,k_in1,k_in2,k_in3,k_in4,k_in5,k_in6,k_in7,k_in8,k_in9,k_in10,k_in11,k_in12,k_in13,k_in14,k_in15,
out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,
clk,
rst,
s_out0,s_out1,s_out2,s_out3,
s_in0,s_in1,s_in2,s_in3,s_rd_en,s_done,
rcon_rd_en,rcon_in,rcon_out,r_done, 
key_rd_en,addr,
key_en,key_done
);
//input signals 
input [7:0] k_in0,k_in1,k_in2,k_in3,k_in4,k_in5,k_in6,k_in7,k_in8,k_in9,k_in10,k_in11,k_in12,k_in13,k_in14,k_in15;
input [7:0] rcon_out;
input r_done;
input clk,rst,s_done;
input [7:0] s_out0,s_out1,s_out2,s_out3;
input [3:0] addr;
input key_rd_en,key_en;

//output signals
output [7:0] out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
output s_rd_en;
output [7:0] s_in0,s_in1,s_in2,s_in3; 
output [7:0] rcon_in;
output rcon_rd_en;
output key_done;

//wires and reg
wire [7:0] k_in0,k_in1,k_in2,k_in3,k_in4,k_in5,k_in6,k_in7,k_in8,k_in9,k_in10,k_in11,k_in12,k_in13,k_in14,k_in15;
wire [7:0] rcon_out;
wire r_done;
wire clk,rst;
wire [7:0] s_out0,s_out1,s_out2,s_out3;
wire key_en;

reg [7:0] out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
reg [7:0] rcon_in;
reg [7:0] s_in0,s_in1,s_in2,s_in3;
reg s_rd_en,rcon_rd_en;
reg key_done;

reg [7:0] reg0 [10:0]; 
reg [7:0] reg1 [10:0]; 
reg [7:0] reg2 [10:0]; 
reg [7:0] reg3 [10:0]; 
reg [7:0] reg4 [10:0]; 
reg [7:0] reg5 [10:0]; 
reg [7:0] reg6 [10:0]; 
reg [7:0] reg7 [10:0]; 
reg [7:0] reg8 [10:0]; 
reg [7:0] reg9 [10:0]; 
reg [7:0] reg10 [10:0]; 
reg [7:0] reg11 [10:0]; 
reg [7:0] reg12 [10:0]; 
reg [7:0] reg13 [10:0]; 
reg [7:0] reg14 [10:0];
reg [7:0] reg15 [10:0]; 
// additional regs 
reg [3:0] count;
reg [3:0] mem_add;
always@(posedge clk)
begin
if (rst)
begin
  out0 =8'b0;
  out1 =8'b0;
  out2 =8'b0;
  out3 =8'b0;
  out4 =8'b0;
  out5 =8'b0;
  out6 =8'b0;
  out7 =8'b0;
  out8 =8'b0;
  out9 =8'b0;
  out10 =8'b0;
  out11 =8'b0;
  out12 =8'b0;
  out13 =8'b0;
  out14 =8'b0;
  out15 =8'b0;
  rcon_in =8'b0;
  s_in0 = 8'b0;
  s_in1 = 8'b0;
  s_in2 =8'b0;
  s_in3 =8'b0;
  s_rd_en =1'b0;
  rcon_rd_en =1'b0;
  count =0;
  mem_add =0;
end
else
begin
if(key_en)
begin
if(mem_add == 0)
begin
	reg0[mem_add]= k_in0;
	reg1[mem_add] = k_in1;
	reg2[mem_add] = k_in2;
	reg3[mem_add]= k_in3;
	reg4[mem_add] = k_in4;
	reg5[mem_add] = k_in5;
	reg6[mem_add]= k_in6;
	reg7[mem_add] = k_in7;
	reg8[mem_add] = k_in8;
	reg9[mem_add]= k_in9;
	reg10[mem_add] = k_in10;
	reg11[mem_add] = k_in11;
	reg12[mem_add]= k_in12;
	reg13[mem_add] = k_in13;
	reg14[mem_add] = k_in14;
	reg15[mem_add] = k_in15;
	count=count+1;
	mem_add = mem_add+1;
end

//else if(count <11 && count!= 0)
else if(mem_add <11)
begin
	s_in0 = reg13[mem_add-1];
	s_in1 = reg14[mem_add-1];
	s_in2 = reg15[mem_add-1];
	s_in3 = reg12[mem_add-1];
	rcon_in = mem_add-1;
	s_rd_en  = 1'b1;
	rcon_rd_en = 1'b1;

	if(s_done == 1'b1 && count%4 == 1)
	begin
		s_rd_en = 1'b0; 
		rcon_rd_en =1'b0;

		//reg12[mem_add] =s_out0;
		//reg13[mem_add] =s_out1;
		//reg14[mem_add] =s_out2;
		//reg15[mem_add] =s_out3;

		reg0[mem_add] = s_out0 ^ reg0[mem_add-1] ^ rcon_out;
		reg1[mem_add] = s_out1 ^ reg1[mem_add-1];
		reg2[mem_add] = s_out2 ^ reg2[mem_add-1];
		reg3[mem_add] = s_out3 ^ reg3[mem_add-1];

		reg4[mem_add] = reg0[mem_add] ^ reg4[mem_add-1];
		reg5[mem_add] = reg1[mem_add] ^ reg5[mem_add-1];
		reg6[mem_add] = reg2[mem_add] ^ reg6[mem_add-1];
		reg7[mem_add] = reg3[mem_add] ^ reg7[mem_add-1];

		reg8[mem_add] = reg4[mem_add] ^ reg8[mem_add-1];
		reg9[mem_add] = reg5[mem_add] ^ reg9[mem_add-1];
		reg10[mem_add] = reg6[mem_add] ^ reg10[mem_add-1];
		reg11[mem_add] = reg7[mem_add] ^ reg11[mem_add-1];

		reg12[mem_add] = reg8[mem_add] ^ reg12[mem_add-1];
		reg13[mem_add] = reg9[mem_add] ^ reg13[mem_add-1];
		reg14[mem_add] = reg10[mem_add] ^ reg14[mem_add-1];
		reg15[mem_add] = reg11[mem_add] ^ reg15[mem_add-1];
	    
        mem_add = mem_add +1;
	end
	count = count+1;
end
else
begin
key_done =1'b1;
end
end
else if(key_rd_en)
begin
count = 0;
out0 =reg0[addr];
out1 =reg1[addr];
out2 =reg2[addr];
out3 =reg3[addr];
out4 =reg4[addr];
out5 =reg5[addr];
out6 =reg6[addr];
out7 =reg7[addr];
out8 =reg8[addr];
out9 =reg9[addr];
out10 =reg10[addr];
out11 =reg11[addr];
out12 =reg12[addr];
out13 =reg13[addr];
out14 =reg14[addr];
out15 =reg15[addr];
end  
else
begin
out0 = out0;
out1 = out1;
out2 = out2;
out3 = out3;
out4 = out4;
out5 = out5;
out6 = out6;
out7 = out7;
out8 = out8;
out9 = out9;
out10 = out10;
out11 = out11;
out12 = out12;
out13 = out13;
out14 = out14;
out15 = out15;

end
end

end


endmodule