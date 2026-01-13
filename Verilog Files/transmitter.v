`timescale 1ns / 1ps

module transmitter(msg,key,tx_data,clk,rst,ready);
input [63:0] msg;
input [79:0] key;
input clk,rst;
output [83:0] tx_data;
output ready;

wire [63:0] prs_enc;

present_encrypt encryptor(.clk(clk) ,.rst(rst) ,.msg(msg) ,.key(key) ,.encrypted(prs_enc) ,.finish(ready));
hamming_enco hamm1(.msg(prs_enc[15:0]) ,.encoded_msg(tx_data[20:0]));
hamming_enco hamm2(.msg(prs_enc[31:16]) ,.encoded_msg(tx_data[41:21]));
hamming_enco hamm3(.msg(prs_enc[47:32]) ,.encoded_msg(tx_data[62:42]));
hamming_enco hamm4(.msg(prs_enc[63:48]) ,.encoded_msg(tx_data[83:63]));

endmodule
