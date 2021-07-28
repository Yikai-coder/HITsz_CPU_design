`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:41:40
// Design Name: 
// Module Name: logic_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// alu下的逻辑运算单元
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module logic_unit #(
    parameter AND = 2'b00,
    parameter OR = 2'b01,
    parameter XOR = 2'b10,
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
            AND:     result_o = op_a_i & op_b_i;
            OR:      result_o = op_a_i | op_b_i;
            XOR:     result_o = op_a_i ^ op_b_i;
            default: result_o = UNKNOWN_OPCODE_RESULT;
        endcase
    end
endmodule
