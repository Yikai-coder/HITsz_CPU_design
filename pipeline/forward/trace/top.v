// Add your code here, or replace this file
module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,
    output  [31:0] debug_wb_pc,
    output       debug_wb_ena,
    output  [4:0]  debug_wb_reg,
    output  [31:0] debug_wb_value
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
wire flush;
reg flush_after_1_cycle;
reg flush_after_2_cycle;
reg flush_after_3_cycle;
reg flush_after_4_cycle;
wire suspend;
reg suspend_after_1_cycle;
reg suspend_after_2_cycle;
reg suspend_after_3_cycle;

reg [2:0] cnt;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        cnt <= 3'h5;
    else
        if(cnt == 2'h0)
            cnt <= cnt;
        else
            cnt <= cnt -1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        suspend_after_1_cycle <= 1'b0;
        suspend_after_2_cycle <= 1'b0;
        suspend_after_3_cycle <= 1'b0;
        flush_after_1_cycle <= 1'b0;
        flush_after_2_cycle <= 1'b0;
        flush_after_3_cycle <= 1'b0;
        flush_after_4_cycle <= 1'b0;
    end
    else begin
        suspend_after_1_cycle <= suspend;
        suspend_after_2_cycle <= suspend_after_1_cycle;        
        suspend_after_3_cycle <= suspend_after_2_cycle;
        flush_after_1_cycle <= flush;
        flush_after_2_cycle <= flush_after_1_cycle;
        flush_after_3_cycle <= flush_after_2_cycle;
        flush_after_4_cycle <= flush_after_3_cycle;        
    end
end



assign debug_wb_have_inst = (cnt==2'h0) & ~flush_after_3_cycle & ~suspend_after_3_cycle & ~flush_after_4_cycle;
// always @(posedge clk) begin
//     debug_wb_value <= debug_value;
// end


my_cpu u_my_cpu(
	.sysclk_i          (clk),
	.reset_i           (rst),
    .inst_i            (inst),
    .pc_o              (pc),
    .wb_pc_o           (debug_wb_pc),
    .npc_o             (debug_wb_pc),
    .mem_we_o          (mem_we),
    .adr_o             (adr),
    .outer_inputdata_o (input_data),
    .outer_outputdata_i(output_data),
    .rf_we_o           (debug_wb_ena),
    .rf_wd_o           (debug_wb_value),
    .rf_wr_o           (debug_wb_reg),
    .suspend_o         (suspend),
    .flush_o           (flush)
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
