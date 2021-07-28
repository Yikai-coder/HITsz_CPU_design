`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 09:22:34
// Design Name: 
// Module Name: reg_mem_wb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module reg_mem_wb(
    input             clk_i,
    input             rst_i,
    input      [31:0] return_pc_i,
    input      [31:0] alu_result_i,
    input      [31:0] mem_rd_i,
    input      [4:0]  wr_i,
    input      [1:0]  wd_sel_i,
    input             regfile_we_i,
    input      [31:0] current_pc_i,
    output reg [31:0] current_pc_o,
    output reg [31:0] return_pc_o,
    output reg [31:0] alu_result_o,
    output reg [31:0] mem_rd_o,
    output reg [4:0]  wr_o,
    output reg [1:0]  wd_sel_o,
    output reg        regfile_we_o
    );
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            return_pc_o <= 32'h0;
        else
            return_pc_o <= return_pc_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            alu_result_o <= 32'h0;
        else
            alu_result_o <= alu_result_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            mem_rd_o <= 32'h0;
        else
            mem_rd_o <= mem_rd_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            wr_o <= 5'h0;
        else
            wr_o <= wr_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            wd_sel_o <= 2'h0;
        else
            wd_sel_o <= wd_sel_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            regfile_we_o <= 1'b0;
        else
            regfile_we_o <= regfile_we_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            current_pc_o <= 32'h0;
        else
            current_pc_o <= current_pc_i;
    end 
endmodule
