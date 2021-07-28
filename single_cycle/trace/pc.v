`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 14:22:58
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// PC寄存器，在每个时钟上升沿将前一个周期送入的npc输出
// 在复位信号送来时输出复位后首条指令的PC值
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module pc#(
    parameter INIT_PC = 32'b0  // 假设0为CPU复位后的首条指令对应地址
)
(
    input      [31:0] npc_i,
    input             clk_i,
    input             reset_i,
    output reg [31:0] pc_o
);
    reg first_time;          // 用于防止reset失效的当个周期时间不够无法完成一条指令，将第一条指令的执行时间推迟到下一次时钟上升沿到来
    always @(posedge clk_i or posedge reset_i) begin
        if(reset_i) begin
            pc_o <= INIT_PC;
            first_time <= 1'b0;
        end
        else begin
            first_time <= 1'b1;
            if(first_time == 1'b0)
                pc_o <= INIT_PC;
            else
                pc_o <= npc_i;
        end
    end
endmodule
