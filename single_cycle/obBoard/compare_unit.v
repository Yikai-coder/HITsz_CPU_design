`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:41:40
// Design Name: 
// Module Name: compare_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 比较运算单元，用于R型与I型指令
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module compare_unit #(
    parameter SIGNED                = 2'b00,
    parameter UNSIGNED              = 2'b01,
    parameter OTHERS                = 32'h0,
    parameter SIGNED_LT             = 32'h1,
    parameter UNSIGNED_LT           = 32'h2,
    parameter UNKNOWN_OPCODE_RESULT = 32'h0
)
(
    input      [31:0] op_a_i,
    input      [31:0] op_b_i,
    input      [1:0]  opcode_i,
    output reg [31:0] result_o
    );
    reg [31:0] tmp;
    always@(*) begin
        case(opcode_i)
            SIGNED: begin
                tmp = op_a_i - op_b_i;
                // 不同号
                if(op_a_i[31]^op_b_i[31])
                    result_o = op_a_i[31];
                else
                    result_o = (tmp[31]==1'b1)?SIGNED_LT:OTHERS;
            end
            UNSIGNED: begin
                result_o = (op_a_i < op_b_i)?UNSIGNED_LT:OTHERS;
            end
            default:
                result_o = UNKNOWN_OPCODE_RESULT;
        endcase
    end
endmodule
