`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/16 14:16:30
// Design Name: 
// Module Name: suspend_o
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


module data_hazard_detect(
    input clk_i,
    input rst_i,
    // input re1_i,
    // input re2_i,
    input [4:0] rR1_id_exe_i,
    input [4:0] rR2_id_exe_i,
    input [4:0] wr_exe_mem_i,
    input [4:0] wr_mem_wb_i,
    input [4:0] wr_wb_i, 
    input detect_r1,
    input detect_r2,
    output      suspend_o
    );
    wire rR1_id_exe_hazard = (rR1_id_exe_i == wr_exe_mem_i)?(wr_exe_mem_i!=5'h0):1'b0;
    wire rR2_id_exe_hazard = (rR2_id_exe_i == wr_exe_mem_i)?(wr_exe_mem_i!=5'h0):1'b0;
    wire rR1_id_mem_hazard = (rR1_id_exe_i == wr_mem_wb_i)?(wr_mem_wb_i!=5'h0):1'b0;
    wire rR2_id_mem_hazard = (rR2_id_exe_i == wr_mem_wb_i)?(wr_mem_wb_i!=5'h0):1'b0;  
    wire rR1_id_wb_hazard = (rR1_id_exe_i == wr_wb_i)?(wr_wb_i!=5'h0):1'b0;
    wire rR2_id_wb_hazard = (rR2_id_exe_i == wr_wb_i)?(wr_wb_i!=5'h0):1'b0;
    assign suspend_o = ((rR1_id_exe_hazard | rR1_id_mem_hazard | rR1_id_wb_hazard) & detect_r1)
                      |((rR2_id_exe_hazard | rR2_id_mem_hazard | rR2_id_wb_hazard) & detect_r2);
    
endmodule
