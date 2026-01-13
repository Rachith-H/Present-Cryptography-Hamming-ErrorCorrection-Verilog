`timescale 1ns / 1ps

module hamming_code_tb;
reg [1:16]msg;
reg [1:21]received_msg;
wire [1:21]encoded_msg;
wire [1:16]decoded_msg;

hamming_enco encoder(msg,encoded_msg);
hamming_deco decoder(received_msg,decoded_msg);

initial begin
msg = 16'h34aa; #1;
received_msg = encoded_msg^21'h010000; #50; 
msg = 16'h2c4a; #1;
received_msg = encoded_msg; #50;
msg = 16'hc86e; #1;
received_msg = encoded_msg^21'h000100; #50;
msg = 16'h9ed5; #1;
received_msg = encoded_msg^21'h000001; #50;
$finish;
end

endmodule


