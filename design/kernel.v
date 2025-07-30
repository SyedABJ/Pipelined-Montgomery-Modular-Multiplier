(* DONT_TOUCH = "TRUE" *)
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


module kernel#(parameter dw = 6,parameter w = 3)(
    input clk,
    input rst,
    input en1,
    input en2,
    input xi,
    input [dw-1:0] Y,
    input [dw-1:0] M,
    input [w-1:0] S0,
    input [w-1:0] S1,
    input [w-1:0] S2,
    output [w-1:0] S0_final,
    output [w-1:0] S1_final,
    output reg [w-1:0] S2_final,
    output done_pe0,
    output done_pe1,
    output reg [3*w - 1:0] S_new,
    output reg done
    );
    localparam e = ((dw+1)+ w - 1)/w; // integer ceiling (don't use $ceil)
    localparam PAD_WIDTH = e * w - dw;// Pad Y and M to e*w bits
    wire [e*w-1:0] Y_padded, M_padded;
    assign Y_padded = {{PAD_WIDTH{1'b0}}, Y};
    assign M_padded = {{PAD_WIDTH{1'b0}}, M};

    // Split Y and M into e words of w bits
    reg [w-1:0] Y_words [0:e-1];
    reg [w-1:0] M_words [0:e-1];
    reg [w-1:0] S_words [0:e-1];
    integer k;
    always @(*) begin
        for (k = 0; k < e; k = k + 1) begin : word_split
            Y_words[k] = Y_padded[k*w +: w];
            M_words[k] = M_padded[k*w +: w];
        end
    end

    reg [w+1:0] temp;
    reg c;
    wire [1:0] cout;
    wire [w-1:0] S1_new;
    reg [1:0] cin;
    reg [w-1:0] S0_old;
    
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
    
    wire [w-1:0] S2_new;
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
               S_words[2] = {cout_final,S2_new[w-1:1]};
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
