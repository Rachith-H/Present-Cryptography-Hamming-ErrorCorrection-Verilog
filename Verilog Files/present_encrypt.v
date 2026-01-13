`timescale 1ns / 1ps

module present_encrypt(clk,rst,msg,key,finish,encrypted);
input clk,rst;
input[63:0] msg;
input [79:0] key;
output [63:0] encrypted;
output finish;

reg [79:0] key_reg;
reg [63:0] state;
reg [4:0]round_counter;
reg done;
integer i;

function [3:0] sbox;
    input [3:0]data;
    begin
        case(data)
        4'h0 : sbox = 4'hC ;
        4'h1 : sbox = 4'h5 ;
        4'h2 : sbox = 4'h6 ;
        4'h3 : sbox = 4'hB ;
        4'h4 : sbox = 4'h9 ;
        4'h5 : sbox = 4'h0 ;
        4'h6 : sbox = 4'hA ;
        4'h7 : sbox = 4'hD ;
        4'h8 : sbox = 4'h3 ;
        4'h9 : sbox = 4'hE ;
        4'hA : sbox = 4'hF ;
        4'hB : sbox = 4'h8 ;
        4'hC : sbox = 4'h4 ;
        4'hD : sbox = 4'h7 ;
        4'hE : sbox = 4'h1 ;
        4'hF : sbox = 4'h2 ;
        endcase
    end
endfunction

function [63:0] operate;
    input [63:0] xored;
    reg [63:0] sub_msg;
    reg [63:0] p_msg;
    begin
        sub_msg[63:60] = sbox(xored[63:60]);
        sub_msg[59:56] = sbox(xored[59:56]);
        sub_msg[55:52] = sbox(xored[55:52]);
        sub_msg[51:48] = sbox(xored[51:48]);
        sub_msg[47:44] = sbox(xored[47:44]);
        sub_msg[43:40] = sbox(xored[43:40]);
        sub_msg[39:36] = sbox(xored[39:36]);
        sub_msg[35:32] = sbox(xored[35:32]);
        sub_msg[31:28] = sbox(xored[31:28]);
        sub_msg[27:24] = sbox(xored[27:24]);
        sub_msg[23:20] = sbox(xored[23:20]);
        sub_msg[19:16] = sbox(xored[19:16]);
        sub_msg[15:12] = sbox(xored[15:12]);
        sub_msg[11:8] = sbox(xored[11:8]);
        sub_msg[7:4] = sbox(xored[7:4]);
        sub_msg[3:0] = sbox(xored[3:0]);
        
        {p_msg[51],p_msg[35],p_msg[19],p_msg[3],p_msg[50],p_msg[34],p_msg[18],p_msg[2],
         p_msg[49],p_msg[33],p_msg[17],p_msg[1],p_msg[48],p_msg[32],p_msg[16],p_msg[0]} = sub_msg[15:0];
         
        {p_msg[55],p_msg[39],p_msg[23],p_msg[7],p_msg[54],p_msg[38],p_msg[22],p_msg[6],
         p_msg[53],p_msg[37],p_msg[21],p_msg[5],p_msg[52],p_msg[36],p_msg[20],p_msg[4]} = sub_msg[31:16];
          
        {p_msg[59],p_msg[43],p_msg[27],p_msg[11],p_msg[58],p_msg[42],p_msg[26],p_msg[10],
         p_msg[57],p_msg[41],p_msg[25],p_msg[9],p_msg[56],p_msg[40],p_msg[24],p_msg[8]}  = sub_msg[47:32];
         
        {p_msg[63],p_msg[47],p_msg[31],p_msg[15],p_msg[62],p_msg[46],p_msg[30],p_msg[14],
         p_msg[61],p_msg[45],p_msg[29],p_msg[13],p_msg[60],p_msg[44],p_msg[28],p_msg[12]} = sub_msg[63:48];
        
        operate = p_msg;
    end
endfunction

always@(posedge clk) begin
    if(rst) begin
        round_counter <= 5'b00001;
        key_reg <= key;
        state <= msg;
        done <= 1'b0;
    end
    
    else begin
        if (!done) begin
            key_reg <= {key_reg[18:0],key_reg[79:19]};
            key_reg[79:76] <= sbox(key_reg[18:15]); 
            key_reg[19:15] <= key_reg[38:34] ^ round_counter;
            state <= operate(state^key_reg[79:16]);
            round_counter <= round_counter + 1 ;
            done <= (round_counter==5'b11111) ? 1'b1 : 1'b0 ;
        end
    end
end

assign finish = done ;
assign encrypted = done ? (state^key_reg[79:16]) : {64{1'b0}} ;

endmodule

