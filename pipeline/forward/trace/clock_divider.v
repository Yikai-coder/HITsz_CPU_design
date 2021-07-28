`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/11 18:57:50
// Design Name: 
// Module Name: time
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
// 分频器，将高频时钟信号转化为低频时钟信号用于驱动数码管
// 输入：时钟信号clk
// 输出：低频时钟信号out
module clock_divider(
    input      clk,
    output reg out
    );
    reg [15:0] cnt = 0;
    reg tag = 1'b0;
    always @ (posedge clk) begin
        if(tag == 1'b0) begin
            out = 1'b0;
            tag = 1'b1;
        end
        else begin
            if(cnt == 16'b1010_0001_0010_0000) begin //27'b101_1111_0101_1110_0001_0000_0000
                out = ~out;
                cnt = 0;
            end
            else begin
                cnt = cnt+1'b1;
            end
        end
    end
endmodule
