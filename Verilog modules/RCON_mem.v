`timescale 1ns / 1ps

module RCON(
in,
out,
addr,
addr0,
wr_en,
rd_en,
done,
rst,
clk
);

input [7:0] in;
input wr_en;
input rd_en;
input [7:0] addr;
input [7:0] addr0;
input rst;
input clk;
output [7:0] out;
output done;

reg [7:0] mem [9:0];
reg [7:0] out;
reg done;
 
always@(posedge clk)
begin
 if(wr_en == 1'b1)
 begin
  done = 1'b0;	
  mem[addr] = in;
 end
 else if(rd_en == 1'b1)
 begin   
   out = mem[addr0];
   done =1'b1;
 end
 else
 begin
	done =1'b0;
end

end
endmodule