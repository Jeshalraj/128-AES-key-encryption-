`timescale 1ns / 1ps

module RCON_tb(
);

reg [7:0] in;
reg wr_en;
reg rd_en;
reg [7:0] addr;
reg rst;
reg clk;
wire [7:0] out;

RCON r(
    .in(in),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.addr(addr),
	.rst(rst),
	.clk(clk),
	.out(out)
);

initial
begin

$monitor("t=%d,out = %d",$time,out);
clk = 1'b0;
rst =1'b1;
#10 rst =1'b0;
wr_en = 1'b1;
addr = 8'h0;
in = 8'h1;
rd_en = 1'b0;

#10 addr = 8'h1;
#10 in = 8'h2;

#10 addr = 8'h2;
#10 in = 8'h4;

#10 addr = 8'h3;
#10 in = 8'h8;

#10 addr = 8'h4;
#10 in = 8'h10;

#10 addr = 8'h5;
#10 in = 8'h20;

#10 addr = 8'h6;
#10 in = 8'h40;

#10 addr = 8'h7;
#10 in = 8'h80;

#10 addr = 8'h8;
#10 in = 8'h1b;

#10 addr = 8'h9;
#10 in = 8'h36;

#5 wr_en = ~ wr_en;

rd_en = ~rd_en;
#10 addr = 8'h0;

#10 addr = 8'h1;

#10 addr = 8'h2;

#10 addr = 8'h3;

#10 addr = 8'h4;

#10 addr = 8'h5;

#10 addr = 8'h6;

#10 addr = 8'h7;

#10 addr = 8'h8;

#10 addr = 8'h9;


end


always
begin
#5 clk =~clk;
end

endmodule 