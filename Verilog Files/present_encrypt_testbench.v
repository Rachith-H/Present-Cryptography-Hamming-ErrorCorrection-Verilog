`timescale 1ns / 1ps

module present_encrypt_testbench;
reg clk,rst;
reg [63:0] msg;
reg [79:0]key;
wire [63:0] enc;
wire ready;

present_encrypt encrypt(clk,rst,msg,key,ready,enc);

always #2 clk = ~clk;
initial begin
clk = 0;
msg = 64'h0000_0000_0000_0000;
key = 80'h0000_0000_0000_0000_0000;
rst =1; #4;
rst =0;
#140;
msg = 64'h0000_0000_0000_0000;
key = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
rst =1; #4;
rst =0;
#140;
msg = 64'hFFFF_FFFF_FFFF_FFFF;
key = 80'h0000_0000_0000_0000_0000;
rst =1; #4;
rst =0;
#140;
msg = 64'hFFFF_FFFF_FFFF_FFFF;
key = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
rst =1; #4;
rst =0;
#140;
$finish;
end
endmodule
