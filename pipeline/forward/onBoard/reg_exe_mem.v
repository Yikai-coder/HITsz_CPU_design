`timescale 1ns/1ps
module reg_exe_mem(
    input             clk_i,
    input             rst_i,
    input      [31:0] alu_result_i,
    input      [31:0] mem_wd_i,
    input             mem_we_i,
    input      [1:0]  mem_data_sel_i,
    input      [4:0]  wr_i,
    input      [1:0]  wd_sel_i,
    input             regfile_we_i,
    input      [31:0] return_pc_i,
    input      [31:0] current_pc_i,
    input             is_sb_i,
    output reg [31:0] current_pc_o,
    output reg [31:0] alu_result_o,
    output reg [31:0] mem_wd_o,
    output reg        mem_we_o,
    output reg [1:0]  mem_data_sel_o,
    output reg [4:0]  wr_o,
    output reg [1:0]  wd_sel_o,
    output reg        regfile_we_o,
    output reg [31:0] return_pc_o,
    output reg        is_sb_o
);
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            alu_result_o <= 32'h0;
        else
            alu_result_o <= alu_result_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            mem_wd_o <= 32'h0;
        else
            mem_wd_o <= mem_wd_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            mem_we_o <= 1'b0;
        else
            mem_we_o <= mem_we_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            mem_data_sel_o <= 2'h0;
        else
            mem_data_sel_o <= mem_data_sel_i;
    end
        always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            wr_o <= 4'h0;
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
            return_pc_o <= 32'h0;
        else
            return_pc_o <= return_pc_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            current_pc_o <= 32'h0;
        else
            current_pc_o <= current_pc_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            is_sb_o <= 1'b0;
        else
            is_sb_o <= is_sb_i;
    end

endmodule