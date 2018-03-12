`timescale 1ns / 1ps

module top();

reg [7:0] in [15:0];
reg [7:0] intext [15:0];
wire [7:0] out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
reg clk;
reg rst;
wire enc_done;

reg [7:0] mem[1023:0];
integer cnt;

Encryptor uut_enc(
in[0],in[1],in[2],in[3],in[4],in[5],in[6],in[7],in[8],in[9],in[10],in[11],in[12],in[13],in[14],in[15],
intext[0],intext[1],intext[2],intext[3],intext[4],intext[5],intext[6],intext[7],intext[8],intext[9],intext[10],intext[11],intext[12],intext[13],intext[14],intext[15],
out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,
rst,enc_done
);

integer data_file, scan_file, flag;
integer data_file1, scan_file1,flag1;
integer i;
integer j;
 

initial 
begin
	data_file =$fopen("C:\\Drive D\\MS UF\\Sem 2\\RC\\Assignments\\Project\\key.txt","r");
	data_file1 =$fopen("C:\\Drive D\\MS UF\\Sem 2\\RC\\Assignments\\Project\\plaintext.txt","r");
	if (data_file == 0) begin
		$display("The file output is NULL");
		$finish;
	end
	if (data_file1 == 0) begin
		$display("The file output is NULL");
		$finish;
	end
	cnt=0;
	clk=1;
	i=0;
	j=0;

end

always@(posedge clk)
begin
	if(!$feof(data_file1)) begin						//Write values to memory Address
		scan_file1 = $fscanf(data_file1,"%c",mem[i]);
		i = i+1;
		end
	else if(i<1025) begin
		mem[i-1] = 8'h00;
		i=i+1;
		rst =1'b1;
	end
	else if(enc_done && cnt <1024) begin
		rst = 1'b1;
        cnt = cnt + 16;
		intext[0] = mem[cnt];
		intext[1] = mem[cnt+1];
		intext[2] = mem[cnt+2];
		intext[3] = mem[cnt+3];
		intext[4] = mem[cnt+4];
		intext[5] = mem[cnt+5];
		intext[6] = mem[cnt+6];
		intext[7] = mem[cnt+7];
		intext[8] = mem[cnt+8];
		intext[9] = mem[cnt+9];
		intext[10] = mem[cnt+10];
		intext[11] = mem[cnt+11];
		intext[12] = mem[cnt+12];
		intext[13] = mem[cnt+13];
		intext[14] = mem[cnt+14];
		intext[15] = mem[cnt+15];
		
			
	end		
	else begin
		rst =1'b0;
		intext[0] = mem[cnt];
		intext[1] = mem[cnt+1];
		intext[2] = mem[cnt+2];
		intext[3] = mem[cnt+3];
		intext[4] = mem[cnt+4];
		intext[5] = mem[cnt+5];
		intext[6] = mem[cnt+6];
		intext[7] = mem[cnt+7];
		intext[8] = mem[cnt+8];
		intext[9] = mem[cnt+9];
		intext[10] = mem[cnt+10];
		intext[11] = mem[cnt+11];
		intext[12] = mem[cnt+12];
		intext[13] = mem[cnt+13];
		intext[14] = mem[cnt+14];
		intext[15] = mem[cnt+15];
	end
	if(!$feof(data_file)) begin						//Write values to memory Address
		scan_file = $fscanf(data_file,"%x\n",in[j]);
		j= j+1;
	end

	
end


always
begin
#5 clk = ~clk;
end

endmodule