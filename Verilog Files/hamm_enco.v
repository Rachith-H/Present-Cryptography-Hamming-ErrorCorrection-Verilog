`timescale 1ns / 1ps

module hamm_enco(msg,encoded_msg);
input [1:16]msg;
output [1:21]encoded_msg;

wire [1:5]p;
assign p[1] = ^{msg[1],msg[2],msg[4],msg[5],msg[7],msg[9],msg[11],msg[12],msg[14],msg[16]};
assign p[2] = ^{msg[1],msg[3:4],msg[6:7],msg[10:11],msg[13:14]};
assign p[3] = ^{msg[2:4],msg[8:11],msg[15:16]};
assign p[4] = ^msg[5:11];
assign p[5] = ^msg[12:16];

assign encoded_msg = {p[1:2],msg[1],p[3],msg[2:4],p[4],msg[5:11],p[5],msg[12:16]};

endmodule