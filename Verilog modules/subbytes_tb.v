//============================================
//
// SubBytes Testbench
//
//============================================



`timescale 1ns / 1ps

module sub_byte_tb();
// Declare inputs as regs and outputs as wires
reg [7:0] in;
reg wr_en, rst, clk;
wire rd_en;
wire [7:0] out0, out1, out2, out3;
wire sub_flag;
//reg [7:0] addr0, addr1, addr2, addr3;
reg [7:0] addr;
wire [7:0] addr0, addr1, addr2, addr3;
reg [7:0] i; 
reg en;
reg [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
wire [7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
wire done;

integer data_file, scan_file, flag;

// -------------------------------------------------------------------------------------
// Port mapping with S_BOX and SubBytes
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
	.addr(addr),
	.addr0(addr0),
	.addr1(addr1),
	.addr2(addr2),
	.addr3(addr3),
	.done(sub_flag)
);

sub_byte U_sub( clk, rst, en, 
				out0, out1, out2, out3,
				sub_flag,
				b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15,
				rd_en,
				addr0, addr1, addr2, addr3,
				s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
				done
			  );

			  
// -------------------------------------------------------------------------------------
// Initial		  
initial begin
	i =1'b0;  
	clk = 1'b0;  
	wr_en = 1'b1;	//Write Enabled
//	rd_en = 1'b0;	//Read Disabled
	addr = 8'b0;
	flag = 0;
	rst = 0;	
	data_file =$fopen("C:\\Drive D\\MS UF\\Sem 2\\RC\\Assignments\\Project\\sbox.txt","r");
	if (data_file == 0) begin
		$display("The file output is NULL");
		$finish;
	end
	$monitor("in=%x,addr0=%d",in,addr0);
end

// -------------------------------------------------------------------------------------
always@(posedge clk)
begin
	if(!$feof(data_file)) begin						//Write values to memory Address
		scan_file = $fscanf(data_file,"%x\n",in);
		if(flag==1) begin
			addr = addr+1;
		end
			flag = 1;
	end
	
	else begin										//Read Value from Memory Address
		wr_en =1'b0;  
		en =1'b1;	// Enable SubBytes
		
		b0 = 8'h00;
		b1 = 8'h01;
		b2 = 8'h02;
		b3 = 8'h03;
		b4 = 8'h04;
		b5 = 8'h05;
		b6 = 8'h06;
		b7 = 8'h07;
		b8 = 8'h08;
		b9 = 8'h09;
		b10 = 8'h10;
		b11 = 8'h11;
		b12 = 8'h12;
		b13 = 8'h13;
		b14 = 8'h14;
		b15 = 8'h15;
		
//		addr0 =8'h00;
//		addr1 =addr0+1;
//		addr2 =addr1+1;
//		addr3 =addr2+1; 
	end
end

always begin
  #5 clk = ~clk; 	// Toggle clock every 5 ticks
end

endmodule 