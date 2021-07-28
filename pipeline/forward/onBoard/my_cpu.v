`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 17:18:09
// Design Name: 
// Module Name: my_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// cpu模块，集成取指�?�译码�?�访存�?�执行�?�控制器五个模块，并完成数据线的连接
// Dependencies: 
// controler，instruction_fetch,instruction_deocder,execute,mem
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module my_cpu(
    input         sysclk_i,           // 晶振时钟输入
    input         reset_i,
    output [31:0] rD19_o
    );
    // 数据信号
    wire cpu_clk;             // cpu时钟信号
    wire [31:0] ext_id;       // 经过拓展处理的立即数
    wire [31:0] ext_exe;
    wire [31:0] rD1_id;          // Regfile读出的reg1
    wire [31:0] rD1_exe;
    wire [31:0] rD2_id;          // Regfile读出的reg2
    wire [31:0] rD2_exe;
    wire [31:0] return_pc_if;    // 用于jal与jalr，将pc+4存储到rd
    wire [31:0] return_pc_id;
    wire [31:0] return_pc_exe;
    wire [31:0] return_pc_mem;
    wire [31:0] return_pc_wb;
    wire [31:0] current_pc_if;   // 用于B型指令，将当前pc值�?�入ALU
    wire [31:0] current_pc_id;
    wire [31:0] current_pc_exe;
    wire [31:0] current_pc_mem;
    wire [31:0] current_pc_wb;
    wire [31:0] inst_if;         // 从imem读出的指�?
    wire [31:0] inst_id;
    wire [31:0] alu_result_exe;   // alu运算结果输出
    wire [31:0] alu_result_mem;
    wire [31:0] alu_result_wb;
    wire [31:0] mem_rd_mem;       // dmem读出数据
    wire [31:0] mem_rd_wb;
    wire [31:0] next_pc;      // npc得到的下一次pc
    wire [13:0] mem_adr_mem;
    wire [31:0] mem_wd_mem;
    wire [4:0]  rR1_id_exe;
    wire [4:0]  rR2_id_exe;
    wire [31:0] forward_data_1; 
    wire [31:0] forward_data_2;
    // 控制信号
    wire [1:0] wd_sel_id;        // 选择写入regfile的数据控制线
    wire [1:0] wd_sel_exe;
    wire [1:0] wd_sel_mem;
    wire [1:0] wd_sel_wb;
    wire [1:0] pc_sel_id;        // pc选择控制�?
    wire [1:0] pc_sel_exe;
    wire branch_controler_id;    // branch控制�?
    wire branch_controler_exe;
    wire branch_exe;          // alu运算结果branch
    wire branch;
    wire [2:0] imm_sel;             // 对立即数拓展单元的控制线，�?�择出合适的立即�?
    wire regfile_we_id;          // Regfile写使能控�?
    wire regfile_we_exe;
    wire regfile_we_mem;
    wire regfile_we_wb;
    wire [4:0] regfile_wr_exe;
    wire [4:0] regfile_wr_mem;
    wire [4:0] regfile_wr_wb;
    wire mem_we_id;              // dmem写使能控�?
    wire mem_we_exe;
    wire mem_we_mem;
    wire op_A_sel_id;            // ALU输入选择信号
    wire op_A_sel_exe;
    wire op_B_sel_id;            // ALU输入选择信号
    wire op_B_sel_exe;
    wire [4:0] alu_opcode_id;    // ALU操作�?
    wire [4:0] alu_opcode_exe;
    wire [1:0] mem_data_sel_id;
    wire [1:0] mem_data_sel_exe;
    wire [1:0] mem_data_sel_mem;
    wire suspend_sig;              // 暂停解决数据冒险
    wire flush;                    // 控制冒险刷新
    wire data_hazard_detect_r1;    // 是否检测r1数据冒险
    wire data_hazard_detect_r2;    // 是否检测r2数据猫心啊
    wire r1_select;                // 前递解决数据冒险
    wire r2_select;
    wire is_load_id;
    wire is_load_exe;
    wire is_sb_id;
    wire is_sb_exe;
    wire is_sb_mem;
    // wire suspend_ctrl;

    // // test
    // reg [31:0] pc_tmp;
    // assign pc_o = current_pc;
    
    // assign adr_o = alu_result[15:2];
    // // assign adr_o = alu_result[14:1];
    // assign mem_we_o = mem_we;
    // assign outer_inputdata_o = rD2;
    // assign branch = branch_controler & branch_exe;


    cpuclk u_cpuclk(
        .clk_in1    (sysclk_i),
        .clk_out1   (cpu_clk)
    );

    controler u_controler(
        .reset_i                (reset_i),
        .opcode_i               (inst_id[6:0]),
        .function7_i            (inst_id[31:25]),
        .function3_i            (inst_id[14:12]),
        .wd_sel_o               (wd_sel_id),   
        .pc_sel_o               (pc_sel_id),   
        .branch_o               (branch_controler_id),     
        .imm_sel_o              (imm_sel),    
        .regfile_we_o           (regfile_we_id), 
        .mem_we_o               (mem_we_id),     
        .op_A_sel_o             (op_A_sel_id),   
        .op_B_sel_o             (op_B_sel_id),   
        .alu_opcode_o           (alu_opcode_id),
        .mem_data_sel_o         (mem_data_sel_id),
        .data_hazard_detect_r1_o(data_hazard_detect_r1),
        .data_hazard_detect_r2_o(data_hazard_detect_r2),
        .is_load_o              (is_load_id),
        .is_sb_o                (is_sb_id)
    );

    instruction_fetch u_instruction_fetch(
        .clk_i          (cpu_clk),
        .reset_i        (reset_i),
        .next_pc_i      (next_pc),
        .data_suspend_i (suspend_sig),
        .flush_i        (flush),
        .inst_o         (inst_if),
        .return_pc_o    (return_pc_if),
        .current_pc_o   (current_pc_if)     // 用于auipc
    );
    
    reg_if_id u_reg_if_id(
        .clk_i       (cpu_clk),
        .rst_i       (reset_i),
        .inst_i      (inst_if),
        .suspend_i   (suspend_sig),
        .current_pc_i(current_pc_if),
        .return_pc_i (return_pc_if),
        .flush_i     (flush),
        .inst_o      (inst_id),
        .current_pc_o(current_pc_id),
        .return_pc_o (return_pc_id)
    );

    instruction_decoder u_instruction_decoder(
        .clk_i           (cpu_clk),
        .reset_i         (reset_i),
        .return_pc_i     (return_pc_wb),
        .ALU_result_i    (alu_result_wb),
        .mem_data_i      (mem_rd_wb),        
        .wd_sel_i        (wd_sel_wb),
        .we_i            (regfile_we_wb),
        .wr_i            (regfile_wr_wb),
        .inst_i          (inst_id),
        .imm_sel_i       (imm_sel),
        .forward_data_1_i(forward_data_1),
        .forward_data_2_i(forward_data_2),
        .r1_select_i     (r1_select),
        .r2_select_i     (r2_select),
        .ext_o           (ext_id),
        .rD1_o           (rD1_id),
        .rD2_o           (rD2_id),
        .rD19_o          (rD19_o)
    );

    reg_id_exe u_reg_id_exe(
        .clk_i              (cpu_clk),
        .rst_i              (reset_i),
        .suspend_i          (suspend_sig),
        .ext_i              (ext_id),
        .rD1_i              (rD1_id),
        .rD2_i              (rD2_id),
        .current_pc_i       (current_pc_id),
        .pc_sel_i           (pc_sel_id),    
        .branch_controler_i (branch_controler_id),   
        .op_A_sel_i         (op_A_sel_id),  
        .op_B_sel_i         (op_B_sel_id),
        .alu_opcode_i       (alu_opcode_id),
        .wr_i               (inst_id[11:7]),
        .rR1_i              (inst_id[19:15]),
        .rR2_i              (inst_id[24:20]),
        .wd_sel_i           (wd_sel_id),
        .regfile_we_i       (regfile_we_id),
        .is_load_i          (is_load_id),
        .is_sb_i            (is_sb_id),
        .mem_we_i           (mem_we_id),
        .mem_data_sel_i     (mem_data_sel_id),
        .return_pc_i        (return_pc_id),
        .flush_i            (flush),
        .ext_o              (ext_exe), 
        .rD1_o              (rD1_exe),
        .rD2_o              (rD2_exe),
        .rR1_o              (rR1_id_exe),
        .rR2_o              (rR2_id_exe),
        .current_pc_o       (current_pc_exe),
        .pc_sel_o           (pc_sel_exe),    
        .branch_controler_o (branch_controler_exe),   
        .op_A_sel_o         (op_A_sel_exe),   
        .op_B_sel_o         (op_B_sel_exe),
        .alu_opcode_o       (alu_opcode_exe),
        .wr_o               (regfile_wr_exe),
        .wd_sel_o           (wd_sel_exe),
        .regfile_we_o       (regfile_we_exe),
        .mem_we_o           (mem_we_exe),
        .mem_data_sel_o     (mem_data_sel_exe),
        .return_pc_o        (return_pc_exe),
        .is_load_o          (is_load_exe),
        .is_sb_o            (is_sb_exe)
    );

    execute u_execute(
        .reset_i            (reset_i),
        .pc_sel_i           (pc_sel_exe),
        .pc_i               (current_pc_exe),
        .branch_controler_i (branch_controler_exe),
        .op_A_sel_i         (op_A_sel_exe),
        .op_B_sel_i         (op_B_sel_exe),
        .current_pc_i       (current_pc_exe),
        .alu_opcode_i       (alu_opcode_exe),
        .rD1_i              (rD1_exe),
        .rD2_i              (rD2_exe),
        .ext_i              (ext_exe),
        .alu_result_o       (alu_result_exe),
        // .alu_branch_o(branch_exe),
        .next_pc_o          (next_pc) 
    );

    jump_examine u_jump_examine(
        .clk_i        (cpu_clk),
        .rst_i        (reset_i),
        .npc_i        (next_pc),
        .current_pc_i (current_pc_exe),
        .flush_o      (flush)
    );

    reg_exe_mem u_reg_exe_mem(
        .clk_i          (cpu_clk),
        .rst_i          (reset_i),
        .alu_result_i   (alu_result_exe),
        .current_pc_i   (current_pc_exe),
        .mem_wd_i       (rD2_exe),
        .mem_we_i       (mem_we_exe),
        .mem_data_sel_i (mem_data_sel_exe),
        .wr_i           (regfile_wr_exe),
        .wd_sel_i       (wd_sel_exe),
        .regfile_we_i   (regfile_we_exe),
        .return_pc_i    (return_pc_exe),
        .alu_result_o   (alu_result_mem),
        .mem_wd_o       (mem_wd_mem),
        .mem_we_o       (mem_we_mem),
        .mem_data_sel_o (mem_data_sel_mem),
        .is_sb_i        (is_sb_exe),
        .wr_o           (regfile_wr_mem), 
        .wd_sel_o       (wd_sel_mem),
        .regfile_we_o   (regfile_we_mem),
        .return_pc_o    (return_pc_mem),
        .current_pc_o   (current_pc_mem),
        .is_sb_o        (is_sb_mem)  
    );
    assign mem_we_o = mem_we_mem;
    mem u_mem(
        .clk_i               (cpu_clk),
        .reset_i             (reset_i),
        .mem_data_sel_i      (mem_data_sel_mem),
        .we_i                (mem_we_mem),
        .adr_i               (alu_result_mem[15:0]),
        .wd_i                (mem_wd_mem),      // 写入信息恒为rD2
        .mem_data_o          (mem_rd_mem)
    );

    reg_mem_wb u_reg_mem_wb(
        .clk_i         (cpu_clk),
        .rst_i         (reset_i),
        .return_pc_i   (return_pc_mem),
        .alu_result_i  (alu_result_mem),
        .mem_rd_i      (mem_rd_mem),
        .wr_i          (regfile_wr_mem),
        .wd_sel_i      (wd_sel_mem),
        .regfile_we_i  (regfile_we_mem),
        .current_pc_i  (current_pc_mem),
        .current_pc_o  (current_pc_wb),
        .return_pc_o   (return_pc_wb),
        .alu_result_o  (alu_result_wb),
        .mem_rd_o      (mem_rd_wb),
        .wr_o          (regfile_wr_wb),
        .wd_sel_o      (wd_sel_wb),
        .regfile_we_o  (regfile_we_wb)
    );

    // 数据冒险检测
    // data_hazard_detect u_data_hazard_detect(
    //     .clk_i         (cpu_clk),
    //     .rst_i         (reset_i),
    //     .rR1_id_exe_i  (inst_id[19:15]),
    //     .rR2_id_exe_i  (inst_id[24:20]),
    //     .wr_exe_mem_i  (regfile_wr_exe),
    //     .wr_mem_wb_i   (regfile_wr_mem),
    //     .wr_wb_i       (regfile_wr_wb),
    //     .suspend_o     (suspend_sig),
    //     .detect_r1     (data_hazard_detect_r1),
    //     .detect_r2     (data_hazard_detect_r2)
    // );
    // 前递单元
    // assign suspend_sig = 1'b0;
    forward_unit u_forward_unit(
        .clk_i           (cpu_clk),
        .rst_i           (reset_i),
        .rR1_id_exe_i    (inst_id[19:15]),
        .rR2_id_exe_i    (inst_id[24:20]),
        .wr_exe_mem_i    (regfile_wr_exe),
        .wr_mem_wb_i     (regfile_wr_mem),
        .wr_wb_i         (regfile_wr_wb),
        .detect_r1_i     (data_hazard_detect_r1),
        .detect_r2_i     (data_hazard_detect_r2),
        .data_exe_i      ((wd_sel_exe==2'b00)?return_pc_exe:alu_result_exe),
        .data_mem_i      ((wd_sel_mem==2'b00)?return_pc_mem:
                          (wd_sel_mem==2'b01)?alu_result_mem:mem_rd_mem),
        .data_wb_i       ((wd_sel_wb==2'b00)?return_pc_wb:
                          (wd_sel_wb==2'b01)?alu_result_wb:mem_rd_wb),
        .forward_data_1_o(forward_data_1),
        .forward_data_2_o(forward_data_2),
        .r1_select_i     (r1_select),
        .r2_select_i     (r2_select),
        .is_load_i       (is_load_exe), 
        .is_sb_exe_i     (is_sb_exe),
        .is_sb_mem_i     (is_sb_mem),
        .suspend_o       (suspend_sig)
    );

endmodule
