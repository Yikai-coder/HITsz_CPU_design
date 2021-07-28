// Add your code here, or replace this file
module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,
    output  [31:0] debug_wb_pc,
    output       debug_wb_ena,
    output  [4:0]  debug_wb_reg,
    output reg [31:0] debug_wb_value
);

wire rst = ~rst_n;
wire [31:0] inst;
wire [31:0] pc;
wire mem_we;
wire [13:0] adr;
wire cpu_clk;
wire [31:0] input_data;
wire [31:0] output_data;
wire debug_ena;
wire [31:0] debug_value;
wire [4:0] debug_reg;
assign debug_wb_pc = pc;



assign debug_wb_have_inst = ~clk & rst_n;
always @(negedge clk) begin
    debug_wb_value <= debug_value;
end


my_cpu u_my_cpu(
	.sysclk_i          (clk),
	.reset_i           (rst),
    .inst_i            (inst),
    .pc_o              (pc),
    .npc_o             (debug_wb_pc),
    .mem_we_o          (mem_we),
    .adr_o             (adr),
    .outer_inputdata_o (input_data),
    .outer_outputdata_i(output_data),
    .rf_we_o           (debug_wb_ena),
    .rf_wd_o           (debug_value),
    .rf_wr_o           (debug_wb_reg)
);

// 下面两个模块，只需要实例化并连线，不需要添加文件

inst_mem imem(
    .a     (pc[15:2]),
    .spo   (inst)
);

data_mem dmem(
    .clk    (clk),            // input wire clka
    .a      (adr),     // input wire [13:0] addra
    .spo   (output_data),        // output wire [31:0] douta
    .we     (mem_we),          // input wire [0:0] wea
    .d      (input_data)         // input wire [31:0] dina
);
endmodule
