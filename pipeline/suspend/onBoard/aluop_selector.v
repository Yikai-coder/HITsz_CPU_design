`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 14:47:37
// Design Name: 
// Module Name: aluop_selector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 根据op_A_sel和op_B_sel选择送入alu的操作输
// op_A:1'b0: 当前pc
//      1'b1: rD1
// op_B:1'b0: imm
//      1'b1: rD2
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module aluop_selector #(
    parameter CURRENTPC = 1'b0,
    parameter RD1       = 1'b1,
    parameter EXT       = 1'b0,
    parameter RD2       = 1'b1
)
(
    input             op_A_sel_i,
    input             op_B_sel_i,
    input      [31:0] current_pc_i,
    input      [31:0] rD1_i,
    input      [31:0] rD2_i,
    input      [31:0] ext_i,
    output reg [31:0] alu_op_a_o,
    output reg [31:0] alu_op_b_o
    );
    // alu_a选择
    always @(*) begin
        case(op_A_sel_i)
            CURRENTPC: alu_op_a_o = current_pc_i;
            RD1:       alu_op_a_o = rD1_i;
            default:   alu_op_a_o = 32'h0;
        endcase
    end
    // alu_b选择
    always @(*) begin
        case(op_B_sel_i)
            EXT: alu_op_b_o = ext_i;
            RD2: alu_op_b_o = rD2_i;
            default: alu_op_b_o = 32'h0;
        endcase
    end
endmodule
