//============================================
//
// Rounds Controller
//
//============================================

`timescale 1ns / 1ps

module rounds_ctr();
// Declare inputs as regs and outputs as wires
reg [7:0] in;
reg wr_en, clk;
reg ss_en, ss_rst, mc_en, mc_rst, add_rst, add_en;
wire rd_en;
wire [7:0] out0, out1, out2, out3;
wire sub_flag;
//reg [7:0] addr0, addr1, addr2, addr3;
reg [7:0] addr;
wire [7:0] addr0, addr1, addr2, addr3;
reg [7:0] i; 
reg sub_en, sel;
reg [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
reg [7:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14, k15;
//wire [7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
wire ss_done, mc_done, add_done;

wire [7:0] ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15;	//Wire between SubShift and MixColumn
wire [7:0] mc0, mc1, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11, mc12, mc13, mc14, mc15;	//Wire between MixColumn and AddRoundKey
wire [7:0] add0, add1, add2, add3, add4, add5, add6, add7, add8, add9, add10, add11, add12, add13, add14, add15;	//Wire between AddRoundKey and SubShift

integer data_file, scan_file, flag;
integer rnd_cnt;

// -------------------------------------------------------------------------------------
// Port mapping of AddRoundKey instance
addroundkey U_addkey(
					clk, add_rst, add_en,
					sel,
					b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15,
					ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15,
					k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14, k15,
					add0, add1, add2, add3, add4, add5, add6, add7, add8, add9, add10, add11, add12, add13, add14, add15,
					add_done
					);		

// Port mapping of SubShift instance
sub_shift U_sub( 
				clk, ss_rst, ss_en, 
				out0, out1, out2, out3,
				sub_flag,
				add0, add1, add2, add3, add4, add5, add6, add7, add8, add9, add10, add11, add12, add13, add14, add15,
				rd_en,
				addr0, addr1, addr2, addr3,
				ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15,
				ss_done
			  );

// Port mapping of S_BOX instance
s_box_rom U_sbox(
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

// Port mapping of Mixcolumn instance
mix_columns U_mixcolumn(
					clk, mc_rst, mc_en,
					ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15,
					mc0, mc1, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11, mc12, mc13, mc14, mc15,
					mc_done
				  );

				  
// -------------------------------------------------------------------------------------
// Initial		  
initial begin
	i =1'b0;  
	clk = 1'b0;  
	wr_en = 1'b1;	//Write Enabled
	addr = 8'b0;
	flag = 0;
//	ss_rst = 1;
//	#10 ss_rst = 0;
	ss_rst = 0;
	rnd_cnt = 1;	
	data_file =$fopen("C:\\Users\\Vim\\Desktop\\UF_Courses\\SPring_17\\RC\\\Project\\Modules\\sbox.txt","r");
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
		wr_en = 1'b0;
		
		if(rnd_cnt==1) begin					// Enable AddRoundKeys and provide intial State and Keys
			add_en 	= 1;		
			sel 	= 0;

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
			b10 = 8'h0A;
			b11 = 8'h0B;
			b12 = 8'h0C;
			b13 = 8'h0D;
			b14 = 8'h0E;
			b15 = 8'h0F;

			k0 = 8'h00;
			k1 = 8'h01;
			k2 = 8'h02;
			k3 = 8'h03;
			k4 = 8'h04;
			k5 = 8'h05;
			k6 = 8'h06;
			k7 = 8'h07;
			k8 = 8'h08;
			k9 = 8'h09;
			k10 = 8'h0A;
			k11 = 8'h0B;
			k12 = 8'h0C;
			k13 = 8'h0D;
			k14 = 8'h0E;
			k15 = 8'h0F;
		end

		if(add_done==1 && rnd_cnt<20) begin		//Start SubShift, AddRoundKey done
			mc_en	= 0;
			ss_en	= 1;
			add_en	= 0;
			rnd_cnt = rnd_cnt + 1;
		end
			
		if(ss_done==1 && rnd_cnt<20) begin		//Start MixColumn, Subshift done
			mc_en	= 1;
			ss_en	= 0;
			add_en	= 0;
		end

		if(mc_done==1 && rnd_cnt<20) begin		//Start AddRoundKey, MixColumn done
			sel		= 0;
			mc_en	= 0;
			ss_en	= 0;
			add_en	= 1;
			
			b0 = mc0;
			b1 = mc1;
			b2 = mc2;
			b3 = mc3;
			b4 = mc4;
			b5 = mc5;
			b6 = mc6;
			b7 = mc7;
			b8 = mc8;
			b9 = mc9;
			b10 = mc10;
			b11 = mc11;
			b12 = mc12;
			b13 = mc13;
			b14 = mc14;
			b15 = mc15;			
		end


		// For last round, skip MixColumn
		if(ss_done==1 && rnd_cnt>=20  && rnd_cnt<22) begin		//Start AddRoundKey after SubShift
			sel		= 1;
			mc_en	= 0;
			ss_en	= 0;
			add_en	= 1;
		end


	end
end

always begin
  #5 clk = ~clk; 	// Toggle clock every 5 ticks
end

endmodule 