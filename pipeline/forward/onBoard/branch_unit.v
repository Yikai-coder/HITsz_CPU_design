`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 16:45:19
// Design Name: 
// Module Name: branch_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// B型指令专用branch运算单元
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module branch_unit#(
    parameter EQ                    = 4'h0,
    parameter NEQ                   = 4'h1,
    parameter UNSIGNED_LT           = 4'h2,
    parameter SIGNED_LT             = 4'h3,
    parameter UNSIGNED_GE           = 4'h4,
    parameter SIGNED_GE             = 4'h5,
    parameter SUCCESS               = 1'b1,
    parameter UNSUCCESS             = 1'b0,
    parameter UNKNOWN_OPCODE_RESULT = 1'b0
)
(
    input      [31:0] op_a_i,
    input      [31:0] op_b_i,
    input      [3:0]  opcode_i,
    output reg        branch
    );
    reg [31:0] tmp;
    always @(*) begin
        tmp = op_a_i - op_b_i;
    end
    always @(*) begin
        case(opcode_i)
            EQ:          branch = (tmp == 32'h0)?SUCCESS:UNSUCCESS;
            NEQ:         branch = (tmp == 32'h0)?UNSUCCESS:SUCCESS;
            UNSIGNED_LT: branch = (op_a_i < op_b_i)?SUCCESS:UNSUCCESS;
            SIGNED_LT: begin
                // 对符号不同的情况特殊处理，防止发生溢出
                if(op_a_i[31] ^ op_b_i[31])
                    branch = op_a_i[31];
                else
                    branch = (tmp[31] == 1'b1)?SUCCESS:UNSUCCESS;
            end   
            UNSIGNED_GE: branch = (op_a_i < op_b_i)?UNSUCCESS:SUCCESS;
            SIGNED_GE: begin
                // 对符号不同的情况特殊处理，防止发生溢出
                if(op_a_i[31] ^ op_b_i[31])
                    branch = op_b_i[31];
                else
                    branch = (tmp[31] == 1'b1)?UNSUCCESS:SUCCESS;
            end
            default:     branch = UNKNOWN_OPCODE_RESULT;
        endcase
    end
endmodule
