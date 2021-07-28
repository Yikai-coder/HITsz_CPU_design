`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 17:22:25
// Design Name: 
// Module Name: execute
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 执行模块，集成alu和alu的数据选择器
// Dependencies: 
// aluop_selector, alu
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module execute(
    input          reset_i,
    input  [1:0]   pc_sel_i,
    input  [31:0]  pc_i,
    input          branch_controler_i,
    input          op_A_sel_i,
    input          op_B_sel_i,
    input  [31:0]  current_pc_i,
    input  [31:0]  rD1_i,
    input  [31:0]  rD2_i,
    input  [31:0]  ext_i,
    input  [4:0]   alu_opcode_i,
    output [31:0]  alu_result_o,
    // output         alu_branch_o,
    output [31:0]  next_pc_o
    );
    wire [31:0] alu_op_a;
    wire [31:0] alu_op_b;
    wire alu_branch;
    wire branch = branch_controler_i & alu_branch;
    aluop_selector u_aluop_selector(
        .op_A_sel_i  (op_A_sel_i),
        .op_B_sel_i  (op_B_sel_i),
        .current_pc_i(current_pc_i),
        .rD1_i       (rD1_i),
        .rD2_i       (rD2_i),
        .ext_i       (ext_i ),
        .alu_op_a_o  (alu_op_a),
        .alu_op_b_o  (alu_op_b)
    );
    alu u_alu(
        .alu_opcode_i   (alu_opcode_i),
        .alu_op_a_i     (alu_op_a),
        .alu_op_b_i     (alu_op_b),
        .alu_result_o   (alu_result_o),
        .branch_o       (alu_branch)
    );
    npc u_npc(
        .reset_i  (reset_i),
        .pc_sel_i (pc_sel_i),
        .pc_i     (pc_i),
        .offset_i (ext_i),
        .rD1_i    (rD1_i),
        .branch_i (branch),
        .next_pc_o(next_pc_o)
    );
endmodule
