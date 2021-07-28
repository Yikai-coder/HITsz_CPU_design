`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 15:31:29
// Design Name: 
// Module Name: instruction_fetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 取指模块
// 包含pc，npc，irom三个子模块
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module instruction_fetch(
    input         clk_i,
    input         reset_i,
    input  [1:0]  pc_sel_i,
    input  [31:0] offset_i,
    input  [31:0] rD1_i,
    input         branch_i,
    output [31:0] inst_o,
    output [31:0] return_pc_o,
    output [31:0] current_pc_o,     // 用于auipc
    output [31:0] pc_o
    );
    wire [31:0] npc;
    wire [31:0] pc;
    assign pc_o = pc;
    assign current_pc_o = pc;
    pc u_pc(
        .npc_i  (npc),
        .clk_i  (clk_i),
        .reset_i(reset_i),
        .pc_o   (pc)
    );
    npc u_npc(
        .reset_i    (reset_i),
        .pc_sel_i   (pc_sel_i),
        .pc_i       (pc),
        .offset_i   (offset_i),
        .rD1_i      (rD1_i),
        .branch_i   (branch_i),
        .next_pc_o  (npc),
        .pc_plus_4_o(return_pc_o)
    );
    // irom u_irom(
    //     .pc_i  (pc),
    //     .inst_o(inst_o)
    // );
endmodule
