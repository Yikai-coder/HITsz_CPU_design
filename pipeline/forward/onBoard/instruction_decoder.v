`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 17:00:09
// Design Name: 
// Module Name: imm_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 译码模块，集成寄存器堆和立即数生成模块
// Dependencies: 
// reg_file,imm_gen
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module instruction_decoder #(
    parameter RETURN_PC =  2'b00,
    parameter ALU_RESULT = 2'b01,
    parameter MEM_DATA =   2'b10
)
(
    input         reset_i,
    input  [31:0] return_pc_i,
    input  [31:0] ALU_result_i,
    input  [31:0] mem_data_i,
    input  [1:0]  wd_sel_i,
    input  [4:0]  wr_i,
    input         we_i,
    input         clk_i,
    input  [31:0] inst_i,
    input  [2:0]  imm_sel_i,
    input  [31:0] forward_data_1_i,
    input  [31:0] forward_data_2_i,
    input         r1_select_i,
    input         r2_select_i,
    output [31:0] wd_o,   // test
    output [31:0] ext_o,
    output [31:0] rD1_o,
    output [31:0] rD2_o,
    output [31:0] rD19_o
    // output reg    write_back  // 写回阶段信号
);

    reg [31:0] wD;
    reg [4:0] wr;
    wire [31:0] rD1;
    wire [31:0] rD2;

    // 根据wd_sel选择写入数据
    // 写入寄存器恒为inst[11:7]
    always @(*) begin
        case(wd_sel_i)
            RETURN_PC: begin
                wD = return_pc_i;
            end 
            ALU_RESULT: begin
                wD = ALU_result_i;
            end
            MEM_DATA: begin 
                wD = mem_data_i;
            end
            default: begin 
                wD = 32'h0;
            end
        endcase
    end
    assign wd_o = wD;
    
    reg_file u_reg_file(
        .clk_i   (clk_i),
        .reset_i (reset_i),
        .rR1_i   (inst_i[19:15]),
        .rR2_i   (inst_i[24:20]),
        .wR_i    (wr_i),
        .wD_i    (wD),
        .WE_i    (we_i),
        .rD1_o   (rD1),
        .rD2_o   (rD2),
        .rD19_o  (rD19_o)        
    );
    // assign we_o = we_i;
    // assign wD_o = wD;
    // assign wR_o = wr;
    assign rD1_o = (r1_select_i==1'b1)?forward_data_1_i:rD1;
    assign rD2_o = (r2_select_i==1'b1)?forward_data_2_i:rD2;

    imm_gen u_imm_gen(
        .reset_i   (reset_i),
        .inst_i    (inst_i),        
        .imm_sel_i (imm_sel_i),
        .ext_o     (ext_o)      
    );
endmodule
