`timescale 1ns/1ps
module forward_unit(
    input       clk_i,
    input       rst_i,
    input [4:0] rR1_id_exe_i,
    input [4:0] rR2_id_exe_i,
    input [4:0] wr_exe_mem_i,
    input [4:0] wr_mem_wb_i,
    input [4:0] wr_wb_i,
    input [31:0] data_exe_i,
    input [31:0] data_mem_i,
    input [31:0] data_wb_i, 
    input detect_r1_i,
    input detect_r2_i,
    input is_load_i,
    input is_sb_exe_i,
    input is_sb_mem_i,
    output [31:0] forward_data_1_o,
    output [31:0] forward_data_2_o,
    output reg r1_select_i,
    output reg r2_select_i,
    output     suspend_o
);
reg [31:0] data_1;
reg [31:0] data_2;
always @(*) begin
    if(detect_r1_i) begin
        if(rR1_id_exe_i == wr_exe_mem_i) begin
            data_1 = data_exe_i;
            r1_select_i = (wr_exe_mem_i!=5'h0) & ~is_sb_exe_i;
        end
        else if(rR1_id_exe_i == wr_mem_wb_i) begin
            data_1 = data_mem_i;
            r1_select_i = (wr_mem_wb_i!=5'h0) & ~is_sb_mem_i;
        end
        else if(rR1_id_exe_i == wr_wb_i) begin
            data_1 = data_wb_i;
            r1_select_i = (wr_wb_i!=5'h0);
        end
        else
            r1_select_i = 1'b0;
    end
    else
        r1_select_i = 1'b0;
end

always @(*) begin
    if(detect_r2_i) begin 
        if(rR2_id_exe_i == wr_exe_mem_i) begin
            data_2 = data_exe_i;
            r2_select_i = (wr_exe_mem_i!=5'h0) & ~is_sb_exe_i;
        end 
        else if(rR2_id_exe_i == wr_mem_wb_i) begin
            data_2 = data_mem_i;
            r2_select_i = (wr_mem_wb_i!=5'h0) & ~is_sb_mem_i;
        end
        else if(rR2_id_exe_i == wr_wb_i) begin
            data_2 = data_wb_i;
            r2_select_i = (wr_wb_i!=5'h0);
        end
        else
            r2_select_i = 1'b0;
    end
    else
        r2_select_i = 1'b0;
end
       
assign forward_data_1_o = data_1;
assign forward_data_2_o = data_2;
// always @(posedge clk_i or posedge rst_i) begin
//     if(rst_i)
//         suspend_o <= 1'b0;
//     else
//         if(is_load_i) begin
//             if(rR1_id_exe_i == wr_exe_mem_i)
//                 suspend_o <= 1'b1;
//             else if(rR2_id_exe_i == wr_exe_mem_i)
//                 suspend_o <= 1'b1;
//             else
//                 suspend_o <= 1'b0;
//         end
//         else
//             suspend_o <= 1'b0;
// end
wire suspend_1 = is_load_i & (rR1_id_exe_i == wr_exe_mem_i) & detect_r1_i;
wire suspend_2 = is_load_i & (rR2_id_exe_i == wr_exe_mem_i) & detect_r2_i;
assign suspend_o = suspend_1 | suspend_2;
endmodule