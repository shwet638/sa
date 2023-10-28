//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 16.10.2023 15:33:55
//// Design Name: 
//// Module Name: top
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module top #(parameter index=0) (input clk,
input [7:0] a,
input [7:0] b,
output reg [15:0] c);
 

reg  [7:0] temp_a;
wire [15:0] temp_c;
reg  [7:0] temp_b;


multiply8 m1(.clk(clk),.a(temp_a),.b(temp_b),.c(temp_c));
always @(posedge clk)
begin
    temp_a<=a;
    temp_b<=b;
    c<=temp_c;
end


 
endmodule
