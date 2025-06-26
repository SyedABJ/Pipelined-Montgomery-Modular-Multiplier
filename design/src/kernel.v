`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2025 12:25:06 PM
// Design Name: 
// Module Name: kernel
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


module kernel(
    input clk,
    input rst,
    input en1,
    input en2,
    input xi,
    input [5:0] Y,
    input [5:0] M,
    input [2:0] S0,
    input [2:0] S1,
    input [2:0] S2,
    output [2:0] S0_final,
    output [2:0] S1_final,
    output reg [2:0] S2_final,
    output done_pe0,
    output done_pe1,
    output reg [8:0] S_new,
    output reg done
    );
    localparam e = 3; //let's fix word length to 3 for the time being
   
    
    // Split Y,M & S into words
    wire [8:0] Y_padded,M_padded;
    assign Y_padded = {3'b000,Y};
    assign M_padded = {3'b000,M};
  
    reg [2:0] Y_words [e-1:0];
    reg [2:0] M_words [e-1:0];
    reg [2:0] S_words [e-1:0];
    integer k;
    always@(*) begin
        for (k = 0; k < e; k = k + 1) begin : word_split
            Y_words[k] = Y_padded[k*3 +: 3];
            M_words[k] = M_padded[k*3 +: 3];
            
        end
    end

    reg [4:0] temp;
    reg c;
    wire [1:0] cout;
    wire [2:0] S1_new;
    reg [1:0] cin;
    reg [2:0] S0_old;
    
    pe pe0 (
        .clk(clk),
        .rst(rst),
        .enable(en1),
        .xi(xi),
        .c(c),
        .Yj(Y_words[1]),
        .Mj(M_words[1]),
        .cin(cin),
        .S0_old(S0_old),
        .S1_old(S1),
        .S0_new(S0_final),
        .S1_new(S1_new),
        .cout(cout),
        .done(done_pe0)
    );
    
    wire [2:0] S2_new;
    wire [1:0] cout_final;
    pe pe1 (
        .clk(clk),
        .rst(rst),
        .xi(xi),
        .enable(en2),
        .c(temp[0]),
        .Yj(Y_words[2]),
        .Mj(M_words[2]),
        .cin(cout),
        .S0_old(S1_new),
        .S1_old(S2),
        .S0_new(S1_final),
        .S1_new(S2_new),
        .cout(cout_final),
        .done(done_pe1)
    );
localparam idle = 3'b000,compute_temp = 3'b001,enable_pe0 = 3'b010,enable_pe1 = 3'b011,finish = 3'b100;
reg [2:0] ps,ns;
always@(posedge clk) 
begin 
if(rst) begin S_new <= 0; cin = 0;done<=0;S0_old <= 0;S2_final<=0;c<=0;ps <= idle; end
else begin 
ps <= ns;
if(done) begin S_words[0] = S0_final; 
               S_words[1] = S1_final; 
               S_words[2] = {cout_final,S2_new[2:1]};
               S2_final = S_words[2];
               S_new = {S_words[2],S_words[1],S_words[0]};
               
               
end
end
end 

always@(*) begin
case(ps)
idle: ns = rst ? idle : compute_temp;
compute_temp: begin temp = xi*Y_words[0] + S0;
                    c = temp[0];
                    {cin,S0_old} = temp + c*M_words[0];
               
                    ns = enable_pe0;
                 
                  end
enable_pe0: begin ns = done_pe0 ? enable_pe1 :enable_pe0;end
enable_pe1: begin ns = done_pe1 ? finish : enable_pe1;end
finish: done = 1;
default: ns = idle;

endcase
end
endmodule
