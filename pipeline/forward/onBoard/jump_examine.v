`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/16 15:03:15
// Design Name: 
// Module Name: jump_examine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 放置在if模块后方检测跳转指令的出现
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jump_examine #(
    parameter JALR_OPCODE = 7'b1100111,
    parameter B_OPCODE = 7'b1100011,
    parameter JAL_OPCODE = 7'b1101111
)
(
    input clk_i,
    input rst_i,
    input [31:0] npc_i,
    input [31:0] current_pc_i,
    output flush_o
    );
    // reg [31:0] pc_1;
    // reg [31:0] pc_2;
    // always @(posedge clk_i or posedge rst_i) begin
    //     if(rst_i) begin
    //         pc_1 <= 32'hfffffffc;
    //         pc_2 <= 32'hfffffffc;
    //     end
    //     else begin
    //         pc_2 <= pc_1;
    //         pc_1 <= current_pc_i;
    //     end
    // end
    assign flush_o = (npc_i!=current_pc_i+3'h4); 
endmodule
