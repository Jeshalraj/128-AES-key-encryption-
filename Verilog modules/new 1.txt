`timescale 1ns / 1ps

module key_ex_tb();
// inputs and outputs of Key_expansion module
reg [7:0] k_in0; 
reg [7:0]  k_in1;
reg [7:0]  k_in2;
reg [7:0]  k_in3;
wire [7:0]  out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
reg clk;
reg rst;
reg [7:0]  s_out0,s_out1,s_out2,s_out3;
wire [7:0]  s_in0,s_in1,s_in2,s_in3;
wire s_rd_en;
reg [7:0]  rcon_in;
reg  key_en;
reg s_done;
// Key_expansion module mapping
key_ex k(
.k_in0(k_in0),
.k_in1(k_in1),
.k_in2(k_in2),
.k_in3(k_in3),
.out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.out5(out5),.out6(out6),.out7(out7),.out8(out8),.out9(out9),.out10(out10),.out11(out11),.out12(out12),.out13(out13),.out14(out14),.out15(out15),
.clk(clk),
.rst(rst),
.s_out0(s_out0),.s_out1(s_out1),.s_out2(s_out2),.s_out3(s_out3),
.s_in0(s_in0),.s_in1(s_in1),.s_in2(s_in2),.s_in3(s_in3),.s_rd_en(s_rd_en),.s_done(s_done),
.rcon_in(rcon_in),
.key_en(key_en)
);

// additional registers 

reg [7:0] rcon [3:0];
reg [7:0] sbox [15:0];
integer count =0; 
integer i =0;
integer j=0;

initial
begin
rcon[0] = 8'h01;
rcon[1] = 8'h02;
rcon[2] = 8'h04;

sbox[0] = 8'h63;
sbox[1] = 8'h7c;
sbox[2] = 8'h77;
sbox[3] = 8'h7b;
sbox[4] = 8'hf2;
sbox[5] = 8'h6b;
sbox[6] = 8'h6f;
sbox[7] = 8'hc5;
sbox[8] = 8'h30;
sbox[9] = 8'h01;
sbox[10] = 8'h67;
sbox[11] = 8'h2b;
sbox[12] = 8'hfe;
sbox[13] = 8'h01;
sbox[14] = 8'h67;
sbox[15] = 8'h2b;

for(j=0; j<16;j=j+1)
begin
 $display("SBOX values: %x",sbox[j]); 
end  
clk =1'b0;
key_en =1'b0;
rst =1'b0;

end


always@(posedge clk)
begin
if(count == 0)
begin
rcon_in =rcon[i];
key_en =1'b1;
k_in0 = 8'h00;
k_in1 = 8'h01;
k_in2 = 8'h02;
k_in3 = 8'h03;
count = count +1;
end
else if(count == 1)
begin
key_en =1'b0;  
k_in0 = 8'h04;
k_in1 = 8'h05;
k_in2 = 8'h06;
k_in3 = 8'h07;
count = count +1;
end
else if(count == 2)
begin
k_in0 = 8'h08;
k_in1 = 8'h09;
k_in2 = 8'h0a;
k_in3 = 8'h0b;
count = count +1;
end
else if(count == 3)
begin
k_in0 = 8'h0c;
k_in1 = 8'h0d;
k_in2 = 8'h0e;
k_in3 = 8'h0f;
count = count +1;
end
else if(s_rd_en == 1'b1)
begin
s_out0 = sbox[s_in0];
s_out1 = sbox[s_in1];
s_out2 = sbox[s_in2];
s_out3 = sbox[s_in3];
$display("The values of inputs given to sbox %x %x %x %x",s_in0,s_in1,s_in2,s_in3);
s_done =1'b1;
i=i+1;
end 
end

always
begin
#5 clk =~clk;
end

endmodule