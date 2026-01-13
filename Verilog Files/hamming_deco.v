`timescale 1ns / 1ps

module hamming_deco (msg,decoded_msg);
input [1:21]msg;
output [1:16]decoded_msg;

wire [1:5]p,syndrome;
wire [1:16]temp_msg;
wire [1:21]corrected_msg,mask;
assign p[1] = ^{msg[1],msg[3],msg[5],msg[7],msg[9],msg[11],msg[13],msg[15],msg[17],msg[19],msg[21]};
assign p[2] = ^{msg[2:3],msg[6:7],msg[10:11],msg[14:15],msg[18:19]};
assign p[3] = ^{msg[4:7],msg[12:15],msg[20:21]};
assign p[4] = ^msg[8:15];
assign p[5] = ^msg[16:21];

assign corrected_msg = |(syndrome) ? msg^mask : msg;
assign syndrome = {p[5],p[4],p[3],p[2],p[1]};
assign temp_msg = {corrected_msg[3],corrected_msg[5:7],corrected_msg[9:15],corrected_msg[17:21]};
assign mask = 21'h100000 >> (syndrome-1);
assign decoded_msg = temp_msg ;

endmodule
