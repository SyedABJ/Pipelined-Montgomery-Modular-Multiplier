`timescale 1ns / 1ps

module pe_tb;

    // Inputs
    reg clk;
    reg rst;
    reg enable;
    reg xi;
    reg c;
    reg [2:0] Yj;
    reg [2:0] Mj;
    reg [1:0] cin;
    reg [2:0] S0_old;
    reg [2:0] S1_old;

    // Outputs
    wire [2:0] S0_new;
    wire [2:0] S1_new;
    wire [1:0] cout;
    wire [2:0] Yj_delayed;
    wire [2:0] Mj_delayed;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    pe dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .xi(xi),
        .c(c),
        .Yj(Yj),
        .Mj(Mj),
        .cin(cin),
        .S0_old(S0_old),
        .S1_old(S1_old),
        .S0_new(S0_new),
        .S1_new(S1_new),
        .cout(cout),
        .Yj_delayed(Yj_delayed),
        .Mj_delayed(Mj_delayed),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock (10ns period)
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        enable = 0;
        xi = 0;
        c = 0;
        Yj = 3'b000;
        Mj = 3'b000;
        cin = 2'b00;
        S0_old = 3'b000;
        S1_old = 3'b000;

        // Dump variables to VCD file
        $dumpfile("pe_tb.vcd");
        $dumpvars(0, pe_tb);

        // Test case 1: Apply reset
        #20;
        rst = 0; // Release reset
        #10;

        // Test case 2: Enable with sample inputs
        enable = 1;
        xi = 1;
        c = 1;
        Yj = 3'b101; // 5
        Mj = 3'b011; // 3
        cin = 2'b01; // 1
        S0_old = 3'b110;
        S1_old = 3'b010;
        #10;

        // Test case 3: Change inputs, keep enable
        xi = 0;
        c = 1;
        Yj = 3'b111; // 7
        Mj = 3'b100; // 4
        cin = 2'b10; // 2
        S0_old = 3'b101;
        S1_old = 3'b011;
        #10;

        // Test case 4: Disable and change inputs
        enable = 0;
        xi = 1;
        c = 0;
        Yj = 3'b001;
        Mj = 3'b010;
        cin = 2'b11;
        S0_old = 3'b000;
        S1_old = 3'b111;
        #10;

        // Test case 5: Re-enable with new inputs
        enable = 1;
        xi = 1;
        c = 1;
        Yj = 3'b110; // 6
        Mj = 3'b101; // 5
        cin = 2'b00; // 0
        S0_old = 3'b011;
        S1_old = 3'b100;
        #10;

        // Test case 6: Reset again
        rst = 1;
        #10;
        rst = 0;
        #10;

        // Finish simulation
        #10;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t rst=%b enable=%b xi=%b c=%b Yj=%b Mj=%b cin=%b S0_old=%b S1_old=%b S0_new=%b S1_new=%b cout=%b Yj_delayed=%b Mj_delayed=%b done=%b",
                 $time, rst, enable, xi, c, Yj, Mj, cin, S0_old, S1_old, S0_new, S1_new, cout, Yj_delayed, Mj_delayed, done);
    end

endmodule
