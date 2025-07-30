`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2025 02:46:03 PM
// Design Name: 
// Module Name: kernel_tb
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
module tb_kernel;

    // Parameters
    parameter DW = 6;
    parameter W = 3;
    parameter CLK_PERIOD = 10; // 10ns clock period (5ns high, 5ns low)

    // Inputs
    reg clk;
    reg rst;
    reg en;
    reg xi;
    reg [DW-1:0] Y;
    reg [DW-1:0] M;
    reg [W-1:0] S0;
    reg [W-1:0] S1;
    reg [W-1:0] S2;

    // Outputs
    wire [W-1:0] S0_final;
    wire [W-1:0] S1_final;
    wire [W-1:0] S2_final;
    wire done_pe0;
    wire done_pe1;
    wire [3*W-1:0] S_new;
    wire done;

    // Instantiate the kernel_scalable module
    kernel_scalable #(
        .dw(DW),
        .w(W)
    ) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .xi(xi),
        .Y(Y),
        .M(M),
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S0_final(S0_final),
        .S1_final(S1_final),
        .S2_final(S2_final),
        .done_pe0(done_pe0),
        .done_pe1(done_pe1),
        .S_new(S_new),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        en = 0;
       
        xi = 0;
        Y = 0;
        M = 0;
        S0 = 0;
        S1 = 0;
        S2 = 0;

        // Apply reset for 20ns
        #20;
        rst = 0;

        $display("Test Case 1: xi = 1, Y = 45, M = 61, S_old = 000000000");
        en = 1;
        xi = 1;
        Y = 6'd37;
        M = 6'd61;
       
        #50; 

        $display("S_new = %b, done = %b", S_new, done);
rst = 1;
#20 rst = 0;
        //Test Case 2: xi = 0, Y = 45, M = 61, S_old = 49
        $display("Test Case 2: xi = 0,S_old = 49");
        xi = 0;
        Y = 6'd37;
        M = 6'd61;
        S0 = 1;
        S1 = 3'd6;
        S2 = 0;
        #50; // Wait for processing (adjust based on pe module latency)

        // Check outputs
        $display("S_new = %b, done = %b", S_new, done);
/*
        // Test Case 3: Reset during operation
        $display("Test Case 3: Apply reset");
        #10;
        rst = 1;
        #20;
        rst = 0;
        $display("S_new = %b, done = %b", S_new, done);

        // Test Case 4: Different inputs, xi toggles
        $display("Test Case 4: xi toggles, Y = 6'b010101, M = 6'b101010, S_old = 9'b101101101");
        Y = 6'b010101;
        M = 6'b101010;
        S_old = 9'b101101101;
        xi = 1;
        #20;
        xi = 0;
        #20;
        xi = 1;
        #20;
        $display("S_new = %b, done = %b", S_new, done);

        // End simulation
        */
        #20;
        $display("Simulation completed");
        $finish;
    end

   
    initial begin
        $monitor("Time=%0t rst=%b xi=%b Y=%b M=%b S0=%b S1=%b S2=%b S_new=%b done=%b",
                 $time, rst, xi, Y, M, S0,S1,S2, S_new, done);
    end

endmodule
