module ko_3 (
    input  [7:0] x,  
    input  [7:0] y,  
    output [15:0] result 
);
    wire [3:0] x1 = x[7:4]; 
    wire [3:0] x0 = x[3:0];
    wire [3:0] y1 = y[7:4]; 
    wire [3:0] y0 = y[3:0]; 

    wire [7:0] A, B, C;
    wire [4:0] x_sum = x1 + x0;
    wire [4:0] y_sum = y1 + y0;
    wire [9:0] D;

   
    assign A = x1 * y1;
    assign C = x0 * y0;
    assign D = x_sum * y_sum;
    assign B = D - A - C;

    //     result: A * 2^8 + B * 2^4 + C
    assign result = (A << 8) + (B << 4) + C;

endmodule
