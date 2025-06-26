module top (
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
assign S = {S2_ke1,S1_ke1,S0_ke1};
assign done = done_ke0 & done_ke1;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*module top (
    input clk,                    
    input rst,                    
    input [5:0] X,                
    input [5:0] Y,                
    input [5:0] M,                
    output reg [8:0] S,           // Changed to reg for synchronous update
    output reg done               // Changed to reg for synchronous update
);
    
    // State definitions
    localparam IDLE  = 3'b000,
               ITER0 = 3'b001,
               ITER1 = 3'b010,
               ITER2 = 3'b011,
               ITER3 = 3'b100,
               ITER4 = 3'b101,
               ITER5 = 3'b110,
               FINISH = 3'b111;

    reg [2:0] ps, ns;             
    reg en1, en2;                 

   
    wire [2:0] S0_ke0, S1_ke0, S2_ke0;
    wire [2:0] S0_ke1, S1_ke1, S2_ke1;
    wire [2:0] S0_ke2, S1_ke2, S2_ke2;
    wire [2:0] S0_ke3, S1_ke3, S2_ke3;
    wire [2:0] S0_ke4, S1_ke4, S2_ke4;
    wire [2:0] S0_ke5, S1_ke5, S2_ke5;

   
    wire done_pe0_ke0, done_pe1_ke0;
    wire done_pe0_ke1, done_pe1_ke1;
    wire done_pe0_ke2, done_pe1_ke2;
    wire done_pe0_ke3, done_pe1_ke3;
    wire done_pe0_ke4, done_pe1_ke4;
    wire done_pe0_ke5, done_pe1_ke5;

    // Done signals from kernels
    wire done_ke0, done_ke1, done_ke2, done_ke3, done_ke4, done_ke5;

    // Output wires from kernels
    wire [8:0] S_new_0, S_new_1, S_new_2, S_new_3, S_new_4, S_new_5;

    // Kernel instances
    kernel ke0 (
        .clk(clk),
        .rst(rst),
        .en1(en1),
        .en2(en2),
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
        .S_new(S_new_0),
        .done(done_ke0)
    );

    kernel ke1 (
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
        .S_new(S_new_1),
        .done(done_ke1)
    );

    kernel ke2 (
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke1),
        .en2(done_pe1_ke1),
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
        .S_new(S_new_2),
        .done(done_ke2)
    );

    kernel ke3 (
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke2),
        .en2(done_pe1_ke2),
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
        .S_new(S_new_3),
        .done(done_ke3)
    );

    kernel ke4 (
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke3),
        .en2(done_pe1_ke3),
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
        .S_new(S_new_4),
        .done(done_ke4)
    );

    kernel ke5 (
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke4),
        .en2(done_pe1_ke4),
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
        .S_new(S_new_5),
        .done(done_ke5)
    );

    // FSM logic
    always @(posedge clk) begin
        if (rst) begin
            ps <= IDLE;
            en1 <= 0;
            en2 <= 0;
            S <= 9'b0;
            done <= 0;
        end else begin
            ps <= ns;
            case (ps)
                ITER0, ITER1, ITER2, ITER3, ITER4, ITER5: begin
                    en1 <= 0; 
                    en2 <= 0;
                end
                FINISH: begin
                    S <= S_new_5 > M ? S_new_5 - M : S_new_5;
                    done <= 1;
                end
                default: begin
                    en1 <= 0;
                    en2 <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        
        case (ps)
            IDLE: ns = rst ? IDLE : ITER0;
            ITER0: begin
                en1 = 1;
                en2 = 1;
                ns = done_ke0 ? ITER1 : ITER0;
            end
            ITER1: begin
                en1 = 0; // Controlled by ke0's done_pe0_ke0
                en2 = 0; // Controlled by ke0's done_pe1_ke0
                ns = done_ke1 ? ITER2 : ITER1;
            end
            ITER2: begin
                en1 = 0; // Controlled by ke1's done_pe0_ke1
                en2 = 0; // Controlled by ke1's done_pe1_ke1
                ns = done_ke2 ? ITER3 : ITER2;
            end
            ITER3: begin
                en1 = 0; // Controlled by ke2's done_pe0_ke2
                en2 = 0; // Controlled by ke2's done_pe1_ke2
                ns = done_ke3 ? ITER4 : ITER3;
            end
            ITER4: begin
                en1 = 0; // Controlled by ke3's done_pe0_ke3
                en2 = 0; // Controlled by ke3's done_pe1_ke3
                ns = done_ke4 ? ITER5 : ITER4;
            end
            ITER5: begin
                en1 = 0; // Controlled by ke4's done_pe0_ke4
                en2 = 0; // Controlled by ke4's done_pe1_ke4
                ns = done_ke5 ? FINISH : ITER5;
            end
            FINISH: ns = IDLE; // Return to idle after completion
            default: ns = IDLE;
        endcase
    end
endmodule


    
 
 
 
 
 
 
    
 localparam idle = 2'b00,iterate = 2'b01,finish = 2'b10;
 reg [1:0] ps,ns;
 reg [8:0] temp;
always@(posedge clk) begin
if(rst) begin
 ps <= idle;
 xi <= 0;
 xi_next <= 0;
 i <= 0;
 S <= 0;
 done <= 0;
end
else begin
ps <= ns;
if(done) begin S <= temp > M ? temp - M : temp; done = 0;end
end
end

always@(*) begin
case(ps)
idle: ns = rst ? idle : iterate;
iterate: begin xi = X[i]; xi_next = X[i+1]; i = i + 2; ns = i < 5 ? iterate : finish;end
finish: begin temp = {S2_ke1,S1_ke1,S0_ke1};done = 1; ns = idle;end
endcase
end
wire [2:0] S0_ke2, S1_ke2, S2_ke2; 
    wire [2:0] S0_ke3, S1_ke3, S2_ke3;
    wire done_pe0_ke2, done_pe1_ke2;   
    wire done_pe0_ke3, done_pe1_ke3;   
    wire done_ke2, done_ke3;           
    wire [8:0] S_new_3,S_new_4;
    kernel ke2 (
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
    kernel ke3 (
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke2),
        .en2(done_pe1_ke2), 
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
    wire [2:0] S0_ke4, S1_ke4, S2_ke4; 
    wire [2:0] S0_ke5, S1_ke5, S2_ke5;
    wire done_pe0_ke4, done_pe1_ke4;   
    wire done_pe0_ke5, done_pe1_ke5;   
    wire done_ke4, done_ke5;           
    wire [8:0] S_new_5,S_new_6;
    kernel ke4 (
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
    kernel ke5 (
        .clk(clk),
        .rst(rst),
        .en1(done_pe0_ke4),
        .en2(done_pe1_ke4), 
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
    
    
       assign done = done_ke0 & done_ke1 & done_ke2 & done_ke3 & done_ke4 & done_ke5;   
       assign S = rst ? 9'b0 : (done ? {S2_ke5,S1_ke5,S0_ke5}: S);
 */ 
