module pe(
input clk,
input rst,
input enable,
input xi,
input c,
input [2:0] Yj,
input [2:0] Mj,
input [1:0] cin,
input [2:0] S0_old,
input [2:0] S1_old,
output reg [2:0] S0_new,
output reg [2:0] S1_new,
output reg [1:0] cout,
output reg done
);
wire [4:0] temp;
assign temp = cin + c*Mj + xi*Yj + S1_old;
always@(posedge clk) begin
if(rst) begin S0_new <= 0; S1_new <= 0; cout = 0;done <= 0;end
else if(enable) begin
{cout,S1_new} = temp;
S0_new = {S1_new[0],S0_old[2:1]};
done = 1;
end
end
endmodule 