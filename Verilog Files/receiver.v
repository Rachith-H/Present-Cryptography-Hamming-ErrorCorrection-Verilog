`timescale 1ns / 1ps

module receiver(clk,rst,rx_data,key,msg,done);
input clk,rst;
input [83:0] rx_data;
input [79:0] key;
output [63:0] msg;
output done;

wire [63:0] hamm_ecc;

hamming_deco hamm1(.msg(rx_data[20:0]) ,.decoded_msg(hamm_ecc[15:0]));
hamming_deco hamm2(.msg(rx_data[41:21]) ,.decoded_msg(hamm_ecc[31:16]));
hamming_deco hamm3(.msg(rx_data[62:42]) ,.decoded_msg(hamm_ecc[47:32]));
hamming_deco hamm4(.msg(rx_data[83:63]) ,.decoded_msg(hamm_ecc[63:48]));

present_decrypt decryptor(.clk(clk) ,.rst(rst) ,.finish(done) ,.encrypted(hamm_ecc) ,.key(key) ,.msg(msg));


endmodule
