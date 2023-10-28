module top_csa #(parameter index=0) (input clk,
input [7:0] a,
input [7:0] b,
output  reg [15:0] c
    );
 reg [7:0] temp_a;
 reg [7:0] temp_b;
 wire [15:0] temp_c;
 mul_array m_1(.a(temp_a),.b(temp_b),.p(temp_c));
 always @(posedge clk)
 begin
    temp_a<=a;
    temp_b<=b;
    c<=temp_c;
 end   
    
endmodule
