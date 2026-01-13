`timescale 1ns / 1ps

module data_transfer_tb;
reg clk ,rst_tx,rst_rx;
reg [63:0] msg_tx;
reg [79:0] key;
wire ready , done;
wire [83:0] tx_data;
wire [63:0] msg_rx;
wire [83:0] rx_data;

transmitter trn(.clk(clk) ,.rst(rst_tx) ,.msg(msg_tx) ,.key(key) ,.tx_data(tx_data) ,.ready(ready));
receiver recv(.clk(clk) ,.rst(rst_rx) ,.rx_data(rx_data) ,.key(key) ,.msg(msg_rx) ,.done(done));

//single bit error injection in each of 4 chunks
assign rx_data = {tx_data[83:64],~tx_data[63],
                  tx_data[62:43],~tx_data[42],
                  tx_data[41:22],~tx_data[21],
                  tx_data[20:1],~tx_data[0]};

always #1 clk = ~clk;
initial begin 
    #70;
    rst_rx=1'b1; #3; 
    rst_rx=1'b0;  
end
initial begin 
clk = 1'b0;
rst_rx = 1'b0;
msg_tx = 64'h0123_4567_89AB_CDEF;
key = 80'h0000_0000_0000_0000_0000;
rst_tx = 1'b1; #2;
rst_tx = 1'b0;
end
initial #240 $finish;
endmodule