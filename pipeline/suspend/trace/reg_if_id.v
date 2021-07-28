`timescale 1ns/1ps
// IF/ID流水线寄存器
module reg_if_id #(
    parameter INIT_PC = 32'h0
)
(
    input             clk_i,
    input             rst_i,
    input      [31:0] inst_i,
    input      [31:0] current_pc_i,
    input      [31:0] return_pc_i,
    input             suspend_i,
    input             flush_i,
    output reg [31:0] inst_o,
    output reg [31:0] current_pc_o,
    output reg [31:0] return_pc_o
);
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            inst_o <= INIT_PC;
        else
            if(flush_i)
                inst_o <= INIT_PC;
            else if(suspend_i)
                inst_o <= inst_o;
            else
                inst_o <= inst_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            current_pc_o <= 32'h0;
        else
            if(flush_i)
                current_pc_o <= 32'h0;
            else if(suspend_i)
                current_pc_o <= current_pc_o;
            else
                current_pc_o <= current_pc_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            return_pc_o <= 32'h0;
        else
            if(flush_i)
                return_pc_o <= 32'h0;
            else if(suspend_i)
                return_pc_o <= return_pc_o;
            else
                return_pc_o <= return_pc_i;
    end
endmodule