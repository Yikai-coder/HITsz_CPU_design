`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:34:04
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 集成算数单元，逻辑运算单元，比较单元，移位单元，以及专用于b型指令的运算单元
// alu_opcode的【3：2】用于选择不同单元的输出结果作为最终输出
// alu_opcode的【1：0】作为不同单元的操作码
// alu_opcode【4】专门用于lui指令直接输出op_b
// Dependencies: 
// arithmetic_unit, compare_unit,logic_unit,shift_unit,branch_unit
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module alu #(
    parameter ARITHMETiC   = 2'b00,
    parameter COMPARE      = 2'b01,
    parameter LOGIC        = 2'b10,
    parameter SHIFT        = 2'b11
)
(
    input      [4:0]  alu_opcode_i,
    input      [31:0] alu_op_a_i,
    input      [31:0] alu_op_b_i,
    output reg [31:0] alu_result_o,
    output            branch_o
);
    wire [31:0] result_arithmetic;
    wire [31:0] result_compare;
    wire [31:0] result_logic;
    wire [31:0] result_shift;    
    // 算数运算单元
    arithmetic_unit u_arithmetic_unit(
        .op_a_i  (alu_op_a_i),
        .op_b_i  (alu_op_b_i),
        .opcode_i(alu_opcode_i[1:0]),
        .result_o(result_arithmetic)
    );
    // 比较操作单元
    compare_unit u_compare_unit(
    .op_a_i  (alu_op_a_i),
    .op_b_i  (alu_op_b_i),
    .opcode_i(alu_opcode_i[1:0]),
    .result_o(result_compare)
    );
    // 逻辑运算单元
    logic_unit u_logic_unit(
    .op_a_i  (alu_op_a_i),
    .op_b_i  (alu_op_b_i),
    .opcode_i(alu_opcode_i[1:0]),
    .result_o(result_logic)
    );
    // 移位运算单元
    shift_unit u_shift_unit(
    .op_a_i  (alu_op_a_i),
    .op_b_i  (alu_op_b_i),
    .opcode_i(alu_opcode_i[1:0]),
    .result_o(result_shift)
    );
    // B型指令专用branch分支运算单元
    branch_unit u_branch_unit(
        .op_a_i  (alu_op_a_i),
        .op_b_i  (alu_op_b_i),
        .opcode_i(alu_opcode_i[3:0]),
        .branch  (branch_o)
    );
    // 根据opcode选择输出哪个单元的结果
    always @(*) begin
        // lui指令
        if(alu_opcode_i[4])
            alu_result_o = alu_op_b_i;
        else
            case(alu_opcode_i[3:2])
                ARITHMETiC: alu_result_o = result_arithmetic;
                COMPARE:    alu_result_o = result_compare;
                LOGIC:      alu_result_o = result_logic;
                SHIFT:      alu_result_o = result_shift;
            endcase
    end

endmodule
