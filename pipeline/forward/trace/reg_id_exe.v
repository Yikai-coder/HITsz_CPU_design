`timescale 1ns/1ps
module reg_id_exe(
    input             clk_i,
    input             rst_i,
    input      [31:0] ext_i,
    input      [4:0]  rR1_i,   // for数据冒险检测
    input      [4:0]  rR2_i,
    input      [31:0] rD1_i,
    input      [31:0] rD2_i,
    input      [31:0] current_pc_i,
    input      [1:0]  pc_sel_i,    
    input             branch_controler_i,   
    input             op_A_sel_i,  
    input             op_B_sel_i,
    input      [4:0]  alu_opcode_i,
    input      [4:0]  wr_i,
    input      [1:0]  wd_sel_i,
    input             regfile_we_i,
    input             mem_we_i,
    input      [1:0]  mem_data_sel_i,
    input      [31:0] return_pc_i,
    input             suspend_i,
    input             flush_i,
    input             is_load_i,
    input             is_sb_i,
    output reg [31:0] ext_o,
    output reg [4:0]  rR1_o,
    output reg [4:0]  rR2_o,
    output reg [31:0] rD1_o,
    output reg [31:0] rD2_o,
    output reg [31:0] current_pc_o,
    output reg [1:0]  pc_sel_o,    
    output reg        branch_controler_o,   
    output reg        op_A_sel_o,  
    output reg        op_B_sel_o,
    output reg [4:0]  alu_opcode_o,
    output reg [4:0]  wr_o,
    output reg [1:0]  wd_sel_o,
    output reg        regfile_we_o,
    output reg        mem_we_o,
    output reg [1:0]  mem_data_sel_o,
    output reg [31:0] return_pc_o,
    output reg        is_load_o,
    output reg        is_sb_o
);
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            ext_o <= 32'h0;
        else
            if(flush_i)
                ext_o <= 32'h0;
            else if(suspend_i)
                ext_o <= ext_o;
            else
                ext_o <= ext_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            rD1_o <= 32'h0;
        else
            if(flush_i)
                rD1_o <= 32'h0;
            else if(suspend_i)
                rD1_o <= rD1_o;
            else
                rD1_o <= rD1_i;
    end    
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            rD2_o <= 32'h0;
        else
            if(flush_i)
                rD2_o <= 32'h0;
            else if(suspend_i)
                rD2_o <= rD2_o;
            else
                rD2_o <= rD2_i;
    end    
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            current_pc_o <= 32'h0;
        else
            // if(flush_i)
            //     current_pc_o <= 32'h0;
            if(suspend_i)
                current_pc_o <= current_pc_o;
            else
                current_pc_o <= current_pc_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            pc_sel_o <= 2'h0;
        else
            if(flush_i)
                pc_sel_o <= 2'h0;
            else if(suspend_i)
                pc_sel_o <= pc_sel_o;
            else
                pc_sel_o <= pc_sel_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            branch_controler_o <= 1'b0;
        else
            if(flush_i)
                branch_controler_o <= 1'b0;
            else if(suspend_i)
                branch_controler_o <= 1'b0;
            else
                branch_controler_o <= branch_controler_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            op_A_sel_o <= 1'b0;
        else
            if(flush_i)
                op_A_sel_o <= 1'b0;
            else if(suspend_i)
                op_A_sel_o <= op_A_sel_o;
            else
                op_A_sel_o <= op_A_sel_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            op_B_sel_o <= 1'b0;
        else
            if(flush_i)
                op_B_sel_o <= 1'b0;
            else if(suspend_i)
                op_B_sel_o <= op_B_sel_o;
            else
                op_B_sel_o <= op_B_sel_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            alu_opcode_o <= 5'h0;
        else
            if(flush_i)
                alu_opcode_o <= 5'h0;
            else if(suspend_i)
                alu_opcode_o <= alu_opcode_o;
            else
                alu_opcode_o <= alu_opcode_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            rR1_o <= 5'h0;
        else
            if(flush_i)
                rR1_o <= 5'h0;
            else if(suspend_i)
                rR1_o <= rR1_o;
            else
                rR1_o <= rR1_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            rR2_o <= 5'h0;
        else
            if(flush_i)
                rR2_o <= 5'h0;
            else if(suspend_i)
                rR2_o <= rR2_o;
            else
                rR2_o <= rR2_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            wr_o <= 5'h0;
        else
            if(flush_i)
                wr_o <= 5'h0;
            else if(suspend_i)
                wr_o <= 5'h0;
            else
                wr_o <= wr_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            wd_sel_o <= 2'h0;
        else
            if(flush_i)
                wd_sel_o <= 2'h0;
            else if(suspend_i)
                wd_sel_o <= wd_sel_o;
            else
                wd_sel_o <= wd_sel_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            regfile_we_o <= 1'b0;
        else
            // 只要保证写存和写寄存器在暂停期间不被多执行即可 
            if(flush_i)
                regfile_we_o <= 1'b0;
            else if(suspend_i)
                regfile_we_o <= 1'b0; 
            else
                regfile_we_o <= regfile_we_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            mem_we_o <= 1'b0;
        else
            // 只要保证写存和写寄存器在暂停期间不被多执行即可 
            if(flush_i)
                mem_we_o <= 1'b0;
            else if(suspend_i)
                mem_we_o <= 1'b0;
            else
                mem_we_o <= mem_we_i;
    end 
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            mem_data_sel_o <= 2'h0;
        else
            if(flush_i)
                mem_data_sel_o <= 2'h0;
            else if(suspend_i)
                mem_data_sel_o <= mem_data_sel_o;
            else
                mem_data_sel_o <= mem_data_sel_i;
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
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            is_load_o <= 1'b0;
        else
            if(flush_i)
                is_load_o <= 1'b0;
            else if(suspend_i)
                is_load_o <= is_load_o;
            else
                is_load_o <= is_load_i;
    end
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            is_sb_o <= 1'b0;
        else
            if(flush_i)
                is_sb_o <= 1'b0;
            else if(suspend_i)
                is_sb_o <= is_sb_o;
            else
                is_sb_o <= is_sb_i;
    end
endmodule
