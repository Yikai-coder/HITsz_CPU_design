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
    input [4:0] rR1_id_exe_i,
    input [4:0] rR2_id_exe_i,
    input [4:0] wr_exe_mem_i,
    input [4:0] wr_mem_wb_i,
    input [4:0] wr_wb_i, 
    input detect_r1,
    input detect_r2,
    output      suspend_o
    );
    // reg [1:0] cnt;
    // always @(posedge clk_i or posedge rst_i) begin
    //     if(rst_i)
    //         suspend_o <= 1'b0;
    //     else begin
    //         // 第一类数据冒险，相邻情况
    //         if(rR1_id_exe_i == wr_exe_mem_i || rR2_id_exe_i == wr_exe_mem_i) 
    //             suspend_o <= 1'b1;
    //         // 第二类数据冒险，相隔1条指令;第三类数据冒险，访存-读取型
    //         else if(rR1_id_exe_i == wr_mem_wb_i || rR2_id_exe_i == wr_mem_wb_i) 
    //             suspend_o <= 1'b1;
    //         else
    //             suspend_o <= 1'b0;
    //     end
    // end
    // always @(posedge clk_i or posedge rst_i) begin
    //     if(rst_i)
    //         cnt <= 2'h0;
    //     else
    //         if(cnt == 2'h0) begin
    //             if((rR1_id_exe_i == wr_exe_mem_i || rR2_id_exe_i == wr_exe_mem_i)&&wr_exe_mem_i!=5'h0)
    //                 cnt <= 2'h3;
    //             else if((rR1_id_exe_i == wr_mem_wb_i || rR2_id_exe_i == wr_mem_wb_i)&&wr_mem_wb_i!=5'h0) 
    //                 cnt <= 2'h2;
    //             else if((rR1_id_exe_i == wr_wb_i || rR2_id_exe_i == wr_wb_i)&&wr_wb_i!=5'h0)
    //                 cnt <= 2'h1;
    //             else
    //                 cnt <= cnt;
    //         end
    //         else
    //             cnt <= cnt - 1'h1;
    // end
    // assign suspend_o = (cnt==2'h0)?1'b0:1'b1;
    wire rR1_id_exe_hazard = (rR1_id_exe_i == wr_exe_mem_i)?(wr_exe_mem_i!=5'h0):1'b0;
    wire rR2_id_exe_hazard = (rR2_id_exe_i == wr_exe_mem_i)?(wr_exe_mem_i!=5'h0):1'b0;
    wire rR1_id_mem_hazard = (rR1_id_exe_i == wr_mem_wb_i)?(wr_mem_wb_i!=5'h0):1'b0;
    wire rR2_id_mem_hazard = (rR2_id_exe_i == wr_mem_wb_i)?(wr_mem_wb_i!=5'h0):1'b0;  
    wire rR1_id_wb_hazard = (rR1_id_exe_i == wr_wb_i)?(wr_wb_i!=5'h0):1'b0;
    wire rR2_id_wb_hazard = (rR2_id_exe_i == wr_wb_i)?(wr_wb_i!=5'h0):1'b0;
    assign suspend_o = ((rR1_id_exe_hazard | rR1_id_mem_hazard | rR1_id_wb_hazard) & detect_r1)
                      |((rR2_id_exe_hazard | rR2_id_mem_hazard | rR2_id_wb_hazard) & detect_r2);
    
endmodule
