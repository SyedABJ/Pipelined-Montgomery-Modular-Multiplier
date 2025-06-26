`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 01:43:30 PM
// Design Name: 
// Module Name: montgomery_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module montgomery_multiplier(
    input clk,
    input rst,
    input [5:0] X,
    input [5:0] Y,
    input [5:0] M,
    output [8:0] S,
    output done
    );
    wire [2:0] S0_ke0, S1_ke0, S2_ke0; 
    wire [2:0] S0_ke1, S1_ke1, S2_ke1;
    wire done_pe0_ke0, done_pe1_ke0;   
    wire done_pe0_ke1, done_pe1_ke1;   
    wire done_ke0, done_ke1;           
    wire [8:0] S_new_1,S_new_2;       
        

    kernel ke0(
        .clk(clk),
        .rst(rst),
        .en1(1),
        .en2(1),
        .xi(X[0]),
        .Y(Y),
        .M(M),
        .S0(3'b0),
        .S1(3'b0),
        .S2(3'b0),
        .S0_final(S0_ke0),
        .S1_final(S1_ke0),
        .S2_final(S2_ke0),
        .done_pe0(done_pe0_ke0),
        .done_pe1(done_pe1_ke0),
        .S_new(S_new_1),
        .done(done_ke0)
    );

    kernel ke1(
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke0),
        .en2(done_pe1_ke0), 
        .xi(X[1]),
        .Y(Y),
        .M(M),
        .S0(S0_ke0),
        .S1(S1_ke0),
        .S2(S2_ke0),
        .S0_final(S0_ke1),
        .S1_final(S1_ke1),
        .S2_final(S2_ke1),
        .done_pe0(done_pe0_ke1),
        .done_pe1(done_pe1_ke1),
        .S_new(S_new_2),
        .done(done_ke1)
    );
    
    wire [2:0] S0_ke2,S1_ke2,S2_ke2;
    wire done_pe0_ke2,done_pe1_ke2;
    wire [8:0] S_new_3;
    
    kernel ke2(
        .clk(clk),
        .rst(rst),
        .en1(done_ke1),
        .en2(done_ke1), 
        .xi(X[2]),
        .Y(Y),
        .M(M),
        .S0(S0_ke1),
        .S1(S1_ke1),
        .S2(S2_ke1),
        .S0_final(S0_ke2),
        .S1_final(S1_ke2),
        .S2_final(S2_ke2),
        .done_pe0(done_pe0_ke2),
        .done_pe1(done_pe1_ke2),
        .S_new(S_new_3),
        .done(done_ke2)
    );
    
    
    wire [2:0] S0_ke3,S1_ke3,S2_ke3;
    wire done_pe0_ke3,done_pe1_ke3;
    wire [8:0] S_new_4;
    kernel ke3(
        .clk(clk),
        .rst(rst),
        .en1(done_ke2),
        .en2(done_ke2), 
        .xi(X[3]),
        .Y(Y),
        .M(M),
        .S0(S0_ke2),
        .S1(S1_ke2),
        .S2(S2_ke2),
        .S0_final(S0_ke3),
        .S1_final(S1_ke3),
        .S2_final(S2_ke3),
        .done_pe0(done_pe0_ke3),
        .done_pe1(done_pe1_ke3),
        .S_new(S_new_4),
        .done(done_ke3)
    );
        
    wire [2:0] S0_ke4,S1_ke4,S2_ke4;
    wire done_pe0_ke4,done_pe1_ke4;
    wire [8:0] S_new_5;
    kernel ke4(
        .clk(clk),
        .rst(rst),
        .en1(done_ke3),
        .en2(done_ke3), 
        .xi(X[4]),
        .Y(Y),
        .M(M),
        .S0(S0_ke3),
        .S1(S1_ke3),
        .S2(S2_ke3),
        .S0_final(S0_ke4),
        .S1_final(S1_ke4),
        .S2_final(S2_ke4),
        .done_pe0(done_pe0_ke4),
        .done_pe1(done_pe1_ke4),
        .S_new(S_new_5),
        .done(done_ke4)
    );
    wire [2:0] S0_ke5,S1_ke5,S2_ke5;
    wire done_pe0_ke5,done_pe1_ke5;
    wire [8:0] S_new_6;
    kernel ke5(
        .clk(clk),
        .rst(rst),
        .en1(done_ke4),
        .en2(done_ke4), 
        .xi(X[5]),
        .Y(Y),
        .M(M),
        .S0(S0_ke4),
        .S1(S1_ke4),
        .S2(S2_ke4),
        .S0_final(S0_ke5),
        .S1_final(S1_ke5),
        .S2_final(S2_ke5),
        .done_pe0(done_pe0_ke5),
        .done_pe1(done_pe1_ke5),
        .S_new(S_new_6),
        .done(done_ke5)
    );
    
    assign S = done ? S_new_6 : 9'b0;
    assign done = done_ke0 & done_ke1 & done_ke2 & done_ke3 & done_ke4 & done_ke5;
    
endmodule
