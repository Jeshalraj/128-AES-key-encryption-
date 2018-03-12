//============================================
//
// S_Box Module
//
//============================================


`timescale 1ns / 1ps

module s_box_rom(
in,
out0,
out1,
out2,
out3,
addr,	//added
addr0,
addr1,
addr2,
addr3,
wr_en,
rd_en,
rst,
clk, 
done
);

input [7:0] in;
input wr_en;
input rd_en;
input [7:0] addr;	//added
input [7:0] addr0;
input [7:0] addr1;
input [7:0] addr2;
input [7:0] addr3;
input rst;
input clk;
output [7:0] out0;
output [7:0] out1;
output [7:0] out2;
output [7:0] out3;
output done;		//added

wire [7:0] in;
wire [7:0] addr;	//added
wire [7:0] addr0;
wire [7:0] addr1;
wire [7:0] addr2;
wire [7:0] addr3;
wire rst;
wire clk;
wire rd_en;
wire wr_en;

reg [7:0] mem [255:0];
reg [7:0] out0;
reg [7:0] out1;
reg [7:0] out2;
reg [7:0] out3;
reg done;

always@(posedge clk)
begin

	if(rst == 1'b1) begin
		out0 = 8'b0;
		out1 = 8'b0;
		out2 = 8'b0;
		out3 = 8'b0;
		done = 0;
	end 

	else if(wr_en == 1'b1) begin
//		mem[addr0] = in;
		mem[addr] = in;		//added
		done = 0;
	end

	else if(rd_en == 1'b1) begin
		done = 1;
		out0 = mem[addr0];
		out1 = mem[addr1];
		out2 = mem[addr2];
		out3 = mem[addr3];
	end
	else
	begin
		done =1'b0;
	end
end

endmodule