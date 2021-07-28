`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:41:40
// Design Name: 
// Module Name: arithmetic_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 算数运算单元，根据传入的两个操作数和操作码进行算术运算
// opcode：00：加法
//         01：减法
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module arithmetic_unit #(
    parameter PLUS                  = 2'b00,
    parameter SUB                   = 2'b01,
    parameter UNKNOWN_OPCODE_RESULT = 32'h0
)
(
    input      [31:0] op_a_i,
    input      [31:0] op_b_i,
    input      [1:0]  opcode_i,
    output reg [31:0] result_o
    );
    always @(*) begin
        case(opcode_i)
            PLUS:    result_o = op_a_i + op_b_i;
            SUB:     result_o = op_a_i + (~op_b_i+1'b1);  // 采用加补码的方式实现减法
            default: result_o = UNKNOWN_OPCODE_RESULT;
        endcase
    end
endmodule
