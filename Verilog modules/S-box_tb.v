`timescale 1ns / 1ps

module S_box_tb(
);

reg [7:0] in;
reg wr_en;
reg rd_en;
reg rst;
reg clk;
wire [7:0] out0;
wire [7:0] out1;
wire [7:0] out2;
wire [7:0] out3;
reg [7:0] addr0;
reg [7:0] addr1;
reg [7:0] addr2;
reg [7:0] addr3;
reg [7:0] i; 
integer data_file;
integer scan_file;
 

s_box_rom s(
    .in(in),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.rst(rst),
	.clk(clk),
	.out0(out0),
	.out1(out1),
	.out2(out2),
	.out3(out3),
	.addr0(addr0),
	.addr1(addr1),
	.addr2(addr2),
	.addr3(addr3)
);

initial
begin
i =1'b0;  
clk = 1'b0;  
wr_en =1'b1;
rd_en =1'b0;
addr0 =8'b0;
data_file =$fopen("C:\\Drive D\\MS UF\\Sem 2\\RC\\Assignments\\Project\\sbox.txt","r");
if (data_file == 0)
begin
$display("The file output is NULL");
$finish;
end
$monitor("in=%x,addr0=%d",in,addr0);
end


always@(posedge clk)
begin
if(!$feof(data_file))
begin
scan_file = $fscanf(data_file,"%x\n",in);
if(addr0<255)
begin
addr0 = addr0+1;
end
end
else 
begin
wr_en =1'b0;  
rd_en =1'b1;
addr0 =8'hfc;
addr1 =addr0+1;
addr2 =addr1+1;
addr3 =addr2+1; 
end
end


always
begin
#5 clk =~clk;
end

endmodule 