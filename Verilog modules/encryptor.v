//============================================
//
// SubBytes Testbench
//
//============================================



`timescale 1ns / 1ps

module Encryptor(
	key0,key1,key2,key3,key4,key5,key6,key7,key8,key9,key10,key11,key12,key13,key14,key15,
	txt0,txt1,txt2,txt3,txt4,txt5,txt6,txt7,txt8,txt9,txt10,txt11,txt12,txt13,txt14,txt15,
	cip0,cip1,cip2,cip3,cip4,cip5,cip6,cip7,cip8,cip9,cip10,cip11,cip12,cip13,cip14,cip15,
	enc_rst,enc_done
);
// input and output ports of the encryptor module
input enc_rst;
input key0,key1,key2,key3,key4,key5,key6,key7,key8,key9,key10,key11,key12,key13,key14,key15;
input txt0,txt1,txt2,txt3,txt4,txt5,txt6,txt7,txt8,txt9,txt10,txt11,txt12,txt13,txt14,txt15;
output cip0,cip1,cip2,cip3,cip4,cip5,cip6,cip7,cip8,cip9,cip10,cip11,cip12,cip13,cip14,cip15;
output enc_done;
wire [7:0] key0,key1,key2,key3,key4,key5,key6,key7,key8,key9,key10,key11,key12,key13,key14,key15;
wire [7:0] txt0,txt1,txt2,txt3,txt4,txt5,txt6,txt7,txt8,txt9,txt10,txt11,txt12,txt13,txt14,txt15;
wire enc_rst;
reg [7:0] cip0,cip1,cip2,cip3,cip4,cip5,cip6,cip7,cip8,cip9,cip10,cip11,cip12,cip13,cip14,cip15;
reg enc_done;
// Declare inputs as regs and outputs as wires
reg [7:0] in,in1;
reg s_wr_en,r_wr_en,rst, clk;
 
//reg [7:0] addr0, addr1, addr2, addr3;
reg [7:0] addr;
reg [7:0] addr1;
// registers for key expansion module
reg [7:0] k_in0,k_in1,k_in2,k_in3,k_in4,k_in5,k_in6,k_in7,k_in8,k_in9,k_in10,k_in11,k_in12,k_in13,k_in14,k_in15;
wire [7:0] out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
reg key_rd_en;
reg [3:0] addr2;
reg key_en;
wire key_done;
reg k_rst;
// connections between key_expansion and sbox
wire [7:0] s_out0,s_out1,s_out2,s_out3;
wire [7:0] key_in0,key_in1,key_in2,key_in3;
wire [7:0] ss_in0,ss_in1,ss_in2,ss_in3;
reg  [7:0] sel_in0,sel_in1,sel_in2,sel_in3;
reg sel_rd_en;
wire key_s_rd_en,ss_s_rd_en;
wire s_done;

// connections between key_expansion and rcon
wire rcon_rd_en,r_done;
wire [7:0] rcon_out,rcon_in; 
// connections for subshift module
reg ss_en;
wire sub_flag;
reg [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
wire [7:0] ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15;
wire ss_done, mc_done, add_done;
// connections for mix_column module
reg mc_en;
wire [7:0] mc0, mc1, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11, mc12, mc13, mc14, mc15;
wire [7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
reg add_en,sel;

integer data_file, scan_file, flag;
integer data_file1, scan_file1,flag1;
integer i,rnd_cnt;

// -------------------------------------------------------------------------------------
// Port mapping with S_BOX and SubBytes
s_box_rom s(
	.in(in),
	.wr_en(s_wr_en),
	.rd_en(sel_rd_en),
	.rst(rst),
	.clk(clk),
	.out0(s_out0),
	.out1(s_out1),
	.out2(s_out2),
	.out3(s_out3),
	.addr(addr),
	.addr0(sel_in0),
	.addr1(sel_in1),
	.addr2(sel_in2),
	.addr3(sel_in3),
	.done(s_done)
);
// port mapping with key_expansion module
key_ex_1 k(
.k_in0(k_in0),.k_in1(k_in1),.k_in2(k_in2),.k_in3(k_in3),.k_in4(k_in4),.k_in5(k_in5),.k_in6(k_in6),.k_in7(k_in7),.k_in8(k_in8),.k_in9(k_in9),.k_in10(k_in10),.k_in11(k_in11),.k_in12(k_in12),.k_in13(k_in13),.k_in14(k_in14),.k_in15(k_in15),
.out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.out5(out5),.out6(out6),.out7(out7),.out8(out8),.out9(out9),.out10(out10),.out11(out11),.out12(out12),.out13(out13),.out14(out14),.out15(out15),
.clk(clk),
.rst(k_rst),
.s_out0(s_out0),.s_out1(s_out1),.s_out2(s_out2),.s_out3(s_out3),
.s_in0(key_in0),.s_in1(key_in1),.s_in2(key_in2),.s_in3(key_in3),.s_rd_en(key_s_rd_en),.s_done(s_done),
.rcon_rd_en(rcon_rd_en),.rcon_in(rcon_in),.rcon_out(rcon_out),.r_done(r_done), 
.key_rd_en(key_rd_en),.addr(addr2),
.key_en(key_en),.key_done(key_done)
);
// port mapping for RCON module
RCON r(
.in(in1),
.out(rcon_out),
.addr(addr1),
.addr0(rcon_in),
.wr_en(r_wr_en),
.rd_en(rcon_rd_en),
.rst(rst),
.clk(clk),
.done(r_done)
);
//port mapping for subshift module
sub_shift U_sub( 
				.clk(clk), .rst(rst), .en(ss_en), 
				.sb_in0(s_out0), .sb_in1(s_out1), .sb_in2(s_out2), .sb_in3(s_out3),
				.sub_flag(s_done),
				.b0(b0), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .b5(b5), .b6(b6), .b7(b7), .b8(b8), .b9(b9), .b10(b10), .b11(b11), .b12(b12), .b13(b13), .b14(b14), .b15(b15),
				.sb_en(ss_s_rd_en),
				.sb_out0(ss_in0), .sb_out1(ss_in1), .sb_out2(ss_in2), .sb_out3(ss_in3),
				.s0(ss0), .s1(ss1), .s2(ss2), .s3(ss3), .s4(ss4), .s5(ss5), .s6(ss6), .s7(ss7), .s8(ss8), .s9(ss9), .s10(ss10), .s11(ss11), .s12(ss12), .s13(ss13), .s14(ss14), .s15(ss15),
				.done(ss_done)
			  );
//port mapping for mix column module
mix_columns U_mixcolumn(
					clk, rst, mc_en,
					ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15,
					mc0, mc1, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11, mc12, mc13, mc14, mc15,
					mc_done
				  );
//port mapping for add_round_key
addroundkey U_addkey(
					clk, rst, add_en,
					sel,
					mc0, mc1, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11, mc12, mc13, mc14, mc15,
					ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15,
					out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15,
					s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
					add_done
					);

// -------------------------------------------------------------------------------------
// Initial		  
initial begin
  
	clk = 1'b0;  
	s_wr_en = 1'b1;	//Write Enabled
	r_wr_en = 1'b1;
	addr = 8'b0;
	addr1 = 8'b0;
	flag = 0;
	flag1 = 0;
	rst = 0;	
	rnd_cnt =0;
	addr2 =1;
	data_file =$fopen("C:\\Drive D\\MS UF\\Sem 2\\RC\\Assignments\\Project\\sbox.txt","r");
	data_file1 =$fopen("C:\\Drive D\\MS UF\\Sem 2\\RC\\Assignments\\Project\\rcon.txt","r");
	if (data_file == 0) begin
		$display("The file output is NULL");
		$finish;
	end
	if (data_file1 == 0) begin
		$display("The file output is NULL");
		$finish;
	end
	k_rst =1'b1;

	#10 k_rst =1'b0;
	rst =1'b0;
	$monitor("in=%x",in);
end

// -------------------------------------------------------------------------------------
always@(posedge clk)
begin


	if(!$feof(data_file1)||!$feof(data_file)) begin						//Write values to memory Address
		scan_file1 = $fscanf(data_file1,"%x\n",in1);
		if(flag1==1) begin
			addr1 = addr1+1;
		end
		flag1 = 1;
	end
	
	if(!$feof(data_file)) begin						//Write values to memory Address
		scan_file = $fscanf(data_file,"%x\n",in);
		if(flag==1) begin
			addr = addr+1;
		end
		flag = 1;
		rnd_cnt = 1;
	end
else begin				
		if(enc_rst)begin
			rst=1;
			rnd_cnt =1;
			enc_done =0;
			addr2 =0;  			//Read Value from Memory Address
		end
		else begin
		rst =1'b0;
		if(key_done == 1'b1)
		begin
		 key_en=1'b0;
		 key_rd_en = 1'b1;
		 rst = 0;


	    if(ss_done==1 && rnd_cnt<18) begin	//Start MixColumn, Subshift done
			mc_en	= 1;
			ss_en	= 0;
			add_en	= 0;
			sel_rd_en =0;
			addr2 = (rnd_cnt+1)/2;
			end

		else if(mc_done==1 && rnd_cnt<18) begin	//Start AddRoundKey, MixColumn done
			sel		= 0;
			mc_en	= 0;
			ss_en	= 0;
			add_en	= 1;
			sel_rd_en =0;

		end

		else if(add_done==1 && rnd_cnt<18) begin	//Start SubShift, AddRoundKey done
			mc_en	= 0;
			ss_en	= 1;
			add_en	= 0;
		    sel_in0 = ss_in0;
		    sel_in1 = ss_in1;
		    sel_in2 = ss_in2;
		    sel_in3 = ss_in3;
			sel_rd_en =ss_s_rd_en;
//			sel_rd_en =1;
			b0 = s0;
			b1 = s1;
			b2 = s2;
			b3 = s3;
			b4 = s4;
			b5 = s5;
			b6 = s6;
			b7 = s7;
			b8 = s8;
			b9 = s9;
			b10 = s10;
			b11 = s11;
			b12 = s12;
			b13 = s13;
			b14 = s14;
			b15 = s15;
//			addr2 =addr2+1;
			
			rnd_cnt = rnd_cnt + 1;			
			
		end
		
		// For last round, skip MixColumn
		else if(ss_done==1 && rnd_cnt>=18  && rnd_cnt<21) begin	//Start AddRoundKey after SubShift
			sel		= 1;
			mc_en	= 0;
			ss_en	= 0;
			add_en	= 1;
			addr2	= 10;
			rnd_cnt = rnd_cnt+1;
		end
		else  if(rnd_cnt==1) begin
			//ss_rst= 0;
			ss_en = 1'b1;		// Enable SubBytes
		    sel_in0 = ss_in0;
		    sel_in1 = ss_in1;
		    sel_in2 = ss_in2;
		    sel_in3 = ss_in3;			
		    sel_rd_en =ss_s_rd_en;
			b0 = k_in0 ^ txt0;
			b1 = k_in1 ^ txt1;
			b2 = k_in2 ^ txt2;
			b3 = k_in3 ^ txt3;
			b4 = k_in4 ^ txt4;
			b5 = k_in5 ^ txt5;
			b6 = k_in6 ^ txt6;
			b7 = k_in7 ^ txt7;
			b8 = k_in8 ^ txt8;
			b9 = k_in9 ^ txt9;
			b10 = k_in10 ^ txt10;
			b11 = k_in11 ^ txt11;
			b12 = k_in12 ^ txt12;
			b13 = k_in13 ^ txt13;
			b14 = k_in14 ^ txt14;
			b15 = k_in15 ^ txt15;
			
		end

		else if(add_done==1'b1 && rnd_cnt==20 && sel_rd_en == 1'b0)
		begin
		cip0= s0;
		cip1= s1;
		cip2= s2;
		cip3= s3;
		cip4= s4;
		cip5= s5;
		cip6= s6;
		cip7= s7;
		cip8= s8;
		cip9= s9;
		cip10= s10;
		cip11= s11;
		cip12= s12;
		cip13= s13;
		cip14= s14;
		cip15= s15;	
		enc_done = 1'b1;	
		add_en =0;
		end
		
		else	
		begin
		    sel_in0 = ss_in0;
		    sel_in1 = ss_in1;
		    sel_in2 = ss_in2;
		    sel_in3 = ss_in3;
			sel_rd_en =ss_s_rd_en;

			//			sel_rd_en =1;		
		end			
		
		end
		
		else
		begin
		key_en =1'b1;
		s_wr_en = 1'b0;	//Write Enabled
		r_wr_en = 1'b0;
		k_in0 = key0;
		k_in1 = key1;
		k_in2 = key2;
		k_in3 = key3;
		k_in4 = key4;  
		k_in5 = key5;
		k_in6 = key6;
		k_in7 = key7;
		k_in8 = key8;
		k_in9 = key9;
		k_in10 = key10;
		k_in11 = key11;
		k_in12 = key12;
		k_in13 = key13;
		k_in14 = key14;
		k_in15 = key15;
		sel_in0 = key_in0;
		sel_in1 = key_in1;
		sel_in2 = key_in2;
		sel_in3 = key_in3;		
		sel_rd_en =key_s_rd_en;
		end
		end
		end
	end


always begin
  #5 clk = ~clk; 	// Toggle clock every 5 ticks
end

endmodule 