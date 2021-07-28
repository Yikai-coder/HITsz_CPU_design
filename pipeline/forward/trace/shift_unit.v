`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:41:40
// Design Name: 
// Module Name: shift_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// alu下的移位操作单元，通过桶形移位器实现
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module shift_unit #(
    parameter LEFT_SHIFT = 2'b00,
    parameter RIGHT_LOGIC_SHIFT = 2'b01,
    parameter RIGHT_ARITHMETIC_SHIFT = 2'b10,
    parameter UNKNOWN_OPCODE_RESULT = 32'h0
)
(
    input  [31:0] op_a_i,
    input  [31:0] op_b_i,  // 实际只有低5位有效，高位是拓展而来
    input  [1:0]  opcode_i,
    output [31:0] result_o
    );
    reg [31:0] tmp;
    always @(*) begin
        case(opcode_i)
            LEFT_SHIFT:begin
                tmp = (op_b_i[0]==1'b1)?{op_a_i[30:0], 1'b0}   :op_a_i;
                tmp = (op_b_i[1]==1'b1)?{tmp[29:0],    2'b0}   :tmp;
                tmp = (op_b_i[2]==1'b1)?{tmp[27:0],    4'b0}   :tmp;
                tmp = (op_b_i[3]==1'b1)?{tmp[23:0],    8'b0}   :tmp;
                tmp = (op_b_i[4]==1'b1)?{tmp[15:0],    16'b0}  :tmp;
            end
            RIGHT_LOGIC_SHIFT:begin
                tmp = (op_b_i[0]==1'b1)?{1'b0,  op_a_i[31:1]}:op_a_i;
                tmp = (op_b_i[1]==1'b1)?{2'b0,  tmp[31:2]}   :tmp;
                tmp = (op_b_i[2]==1'b1)?{4'b0,  tmp[31:4]}   :tmp;
                tmp = (op_b_i[3]==1'b1)?{8'b0,  tmp[31:8]}   :tmp;
                tmp = (op_b_i[4]==1'b1)?{16'b0, tmp[31:16]}  :tmp; 
            end
            RIGHT_ARITHMETIC_SHIFT: begin
                tmp = (op_b_i[0]==1'b1)?{{1{op_a_i[31]}},  op_a_i[31:1]}:op_a_i;
                tmp = (op_b_i[1]==1'b1)?{{2{op_a_i[31]}},  tmp[31:2]}   :tmp;
                tmp = (op_b_i[2]==1'b1)?{{4{op_a_i[31]}},  tmp[31:4]}   :tmp;
                tmp = (op_b_i[3]==1'b1)?{{8{op_a_i[31]}},  tmp[31:8]}   :tmp;
                tmp = (op_b_i[4]==1'b1)?{{16{op_a_i[31]}}, tmp[31:16]}  :tmp; 
            end
            default: tmp = UNKNOWN_OPCODE_RESULT;
        endcase
    end
    assign result_o = tmp;
endmodule
