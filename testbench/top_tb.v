`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2025 06:20:35 PM
// Design Name: 
// Module Name: top_tb
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


`timescale 1ns / 1ps

module top_tb;
    // Inputs
    reg clk;
    reg rst;
    reg [11:0] X;
    reg [11:0] Y;
    reg [11:0] M;
    // Outputs
    wire [11:0] S;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    montgomery_multiplier uut (
        .clk(clk),
        .rst(rst),
        .X(X),
        .Y(Y),
        .M(M),
        .S(S),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #1.5 clk = ~clk; // 100 MHz clock (10ns period)
    end

    // Stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        X = 12'd1234; // X = 45
        Y = 12'd2345; // Y = 37
        M = 12'd4093; // M = 61

        // Apply reset
        #20;
        rst = 0;

        // Wait for done signal
        

        // Check result
        $display("Test: X=%d, Y=%d, M=%d", X, Y, M);
        $display("Output: S=%d, done=%b", S, done);
        if (S == 12'd4079)
            $display("Test PASSED: Expected S=4079, Got S=%d", S);
        else
            $display("Test FAILED: Expected S=4079, Got S=%d", S);

        // End simulation
     
    end

    // Monitor
    initial begin
        $monitor("Time=%t, rst=%b, X=%d, Y=%d, M=%d, S=%d, done=%b", 
                 $time, rst, X, Y, M, S, done);
    end
endmodule
