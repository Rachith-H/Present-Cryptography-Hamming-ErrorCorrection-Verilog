`timescale 1ns / 1ps

module present_decrypt(clk,rst,key,encrypted,finish,msg);
input clk,rst;
input [63:0] encrypted;
input [79:0] key;
output [63:0] msg;
output finish;

reg [79:0] key_reg [31:0];
reg decrypt,key_gen,done,skip;
reg [4:0]round_counter;
reg [63:0] state;

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

function [3:0] s_inv;
    input [3:0] data;
    begin
        case(data) 
        4'hC : s_inv = 4'h0 ;
        4'h5 : s_inv = 4'h1 ;
        4'h6 : s_inv = 4'h2 ;
        4'hB : s_inv = 4'h3 ;
        4'h9 : s_inv = 4'h4 ;
        4'h0 : s_inv = 4'h5 ;
        4'hA : s_inv = 4'h6 ;
        4'hD : s_inv = 4'h7 ;
        4'h3 : s_inv = 4'h8 ;
        4'hE : s_inv = 4'h9 ;
        4'hF : s_inv = 4'hA ;
        4'h8 : s_inv = 4'hB ;
        4'h4 : s_inv = 4'hC ;
        4'h7 : s_inv = 4'hD ;
        4'h1 : s_inv = 4'hE ;
        4'h2 : s_inv = 4'hF ;
        endcase 
    end
endfunction

function [63:0] operate;
    input [63:0] rev;
    reg [63:0] p_inv;
    reg [63:0] new_msg;
    begin
        p_inv[15:0] = {rev[51],rev[35],rev[19],rev[3],rev[50],rev[34],rev[18],rev[2],
                       rev[49],rev[33],rev[17],rev[1],rev[48],rev[32],rev[16],rev[0]};
        p_inv[31:16] = {rev[55],rev[39],rev[23],rev[7],rev[54],rev[38],rev[22],rev[6],
                        rev[53],rev[37],rev[21],rev[5],rev[52],rev[36],rev[20],rev[4]};
        p_inv[47:32] = {rev[59],rev[43],rev[27],rev[11],rev[58],rev[42],rev[26],rev[10],
                        rev[57],rev[41],rev[25],rev[9],rev[56],rev[40],rev[24],rev[8]};
        p_inv[63:48] = {rev[63],rev[47],rev[31],rev[15],rev[62],rev[46],rev[30],rev[14],
                        rev[61],rev[45],rev[29],rev[13],rev[60],rev[44],rev[28],rev[12]};
                        
        new_msg[63:60] = s_inv(p_inv[63:60]);
        new_msg[59:56] = s_inv(p_inv[59:56]);
        new_msg[55:52] = s_inv(p_inv[55:52]);
        new_msg[51:48] = s_inv(p_inv[51:48]);
        new_msg[47:44] = s_inv(p_inv[47:44]);
        new_msg[43:40] = s_inv(p_inv[43:40]);
        new_msg[39:36] = s_inv(p_inv[39:36]);
        new_msg[35:32] = s_inv(p_inv[35:32]);
        new_msg[31:28] = s_inv(p_inv[31:28]);
        new_msg[27:24] = s_inv(p_inv[27:24]);
        new_msg[23:20] = s_inv(p_inv[23:20]);
        new_msg[19:16] = s_inv(p_inv[19:16]);
        new_msg[15:12] = s_inv(p_inv[15:12]);
        new_msg[11:8] = s_inv(p_inv[11:8]);
        new_msg[7:4] = s_inv(p_inv[7:4]);
        new_msg[3:0] = s_inv(p_inv[3:0]);
        
        operate = new_msg ;
    end
endfunction

always@(posedge clk) begin
    if(rst) begin
        round_counter <= 5'b00001;
        state <= encrypted;
        key_reg[0] <= key;
        key_gen <= 1'b1;
        decrypt <= 1'b0;
        done <= 1'b0;
        skip <= 1'b0;
    end
    
    else if(key_gen) begin
        key_reg[round_counter] <= {key_reg[round_counter-1][18:0],key_reg[round_counter-1][79:19]};
        key_reg[round_counter][79:76] <= sbox(key_reg[round_counter-1][18:15]);
        key_reg[round_counter][19:15] <= key_reg[round_counter-1][38:34] ^ round_counter;
        round_counter <= round_counter + 1 ;
        {key_gen,decrypt} <= (round_counter==5'b11111) ? 2'b01 : 2'b10 ;        
    end
    
    else if (decrypt) begin
        if (round_counter==5'b00000 & !skip) begin
            state <= state^key_reg[31][79:16];
            round_counter <= 5'b11110;
            skip <= 1'b1;
        end
        else begin
            state <= (round_counter==5'b11111) ? state : operate(state)^ key_reg[round_counter][79:16];
            round_counter <= round_counter-1;
            {decrypt,done} <= (round_counter==5'b11111) ? 2'b01 : 2'b10 ;
        end
    end

end

assign msg = done ? state : {64{1'bz}};
assign finish = done;
endmodule
