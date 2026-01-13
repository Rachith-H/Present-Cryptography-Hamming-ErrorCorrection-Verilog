`timescale 1ns / 1ps

module present_decrypt_tb;
reg clk,rst;
reg [79:0]key;
reg [63:0] enc;
wire [63:0] msg;
wire done;
present_decrypt decrypt(clk,rst,key,enc,done,msg);

always #2 clk = ~clk;
initial begin
clk = 0;
enc = 64'h5579_C138_7B22_8445;
key = 80'h0000_0000_0000_0000_0000;
rst =1; #4;
rst =0;
#300;
enc = 64'hE72C_46C0_F594_5049;
key = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
rst =1; #4;
rst =0;
#300;
enc = 64'hA112_FFC7_2F68_417B;
key = 80'h0000_0000_0000_0000_0000;
rst =1; #4;
rst =0;
#300;
enc = 64'h3333_DCD3_2132_10D2;
key = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
rst =1; #4;
rst =0;
#300;
$finish;
end
endmodule