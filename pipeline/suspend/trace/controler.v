`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/04 09:12:29
// Design Name: 
// Module Name: controler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 控制器，接收解码器发送的opcode，function3，function7字段
// 输出各种控制信号
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controler #(
    parameter OPCODE_JAL   = 7'b1101111,
    parameter OPCODE_JALR  = 7'b1100111,
    parameter OPCODE_LOAD  = 7'b0000011,
    parameter OPCODE_B     = 7'b1100011,
    parameter OPCODE_R     = 7'b0110011,
    parameter OPCODE_I     = 7'b0010011,
    parameter OPCODE_S     = 7'b0100011,
    parameter OPCODE_AUIPC = 7'b0010111,
    parameter OPCODE_LUI   = 7'b0110111

)
(
    input             reset_i,
    input      [6:0]  opcode_i,
    input      [6:0]  function7_i,
    input      [2:0]  function3_i,
    output reg [1:0]  wd_sel_o,      // Regfile写入数据选择信号
    output reg [1:0]  pc_sel_o,      // npc选择信号
    output reg        branch_o,      // B型指令允许跳转信号 
    output reg [2:0]  imm_sel_o,     // 立即数选择信号     
    output reg        regfile_we_o,  // Regfile写允许信号
    output reg        mem_we_o,      // Mem写允许信号
    output reg        op_A_sel_o,    // ALU输入选择信号
    output reg        op_B_sel_o,    // ALU输入选择信号   
    output reg [4:0]  alu_opcode_o,  // alu操作码
    output reg [1:0]  mem_data_sel_o, // Mem数据选择信号，用于处理sb,sh，lb,lh
    output            data_hazard_detect_r1_o,  // 控制数据冒险检测单元检测r1和r2
    output             data_hazard_detect_r2_o 
    );
    // wd_sel赋值处理
    always @(*) begin
        if(reset_i == 1'b1)
            wd_sel_o = 2'b11;
        else begin
            case(opcode_i)
                // jal,jalr
                OPCODE_JAL,OPCODE_JALR:
                    wd_sel_o = 2'b00;
                // lb,lw,ld
                OPCODE_LOAD:
                    wd_sel_o = 2'b10;
                // others
                default:
                    wd_sel_o = 2'b01;
            endcase
        end
    end

    // pc_sel赋值处理
    always @(*) begin
        if(reset_i == 1'b1)
            pc_sel_o = 2'b00;
        else begin
            case(opcode_i)
                // B型指令
                OPCODE_B:
                    pc_sel_o = 2'b01;
                // jalr
                OPCODE_JALR:
                    pc_sel_o = 2'b11;
                // jal
                OPCODE_JAL:
                    pc_sel_o = 2'b10;
                default:
                    pc_sel_o = 2'b00;
            endcase
        end
    end

    // branch赋值处理
    always @(*) begin
        if(reset_i == 1'b1)
            branch_o = 1'b0;
        else begin
            case(opcode_i)
                // B型指令
                OPCODE_B:
                    branch_o = 1'b1;
                default:
                    branch_o = 1'b0;
            endcase
        end
    end

    // imm_sel赋值处理
    always @(*) begin
        if(reset_i == 1'b1)
            imm_sel_o = 3'b000;
        else begin
            case(opcode_i)
                // R型指令
                OPCODE_R:
                    imm_sel_o = 3'b000;
                // I型指令立即数操作与移位运算
                OPCODE_I: begin
                    case(function3_i)
                        // 移位操作
                        3'b001, 3'b101:
                            imm_sel_o = 3'b010;
                        default:
                            imm_sel_o = 3'b001;
                    endcase
                end
                // lb,lh,lw,jalr
                OPCODE_LOAD, OPCODE_JALR:
                    imm_sel_o = 3'b001;
                // S型
                OPCODE_S:
                    imm_sel_o = 3'b011;
                // B型
                OPCODE_B:
                    imm_sel_o = 3'b100;
                OPCODE_AUIPC, OPCODE_LUI:
                    imm_sel_o = 3'b101;
                OPCODE_JAL:
                    imm_sel_o = 3'b110;
                default:;
            endcase
        end
    end

    // regfile_we_o处理
    always @(*) begin
        if(reset_i == 1'b1)
            regfile_we_o = 1'b0;
        else begin
            case(opcode_i)
                // R型，I型，U型，J型需要写寄存器 
                OPCODE_R,
                OPCODE_I, 
                OPCODE_LOAD, 
                OPCODE_JAL, 
                OPCODE_LUI,
                OPCODE_AUIPC, 
                OPCODE_JALR:
                    regfile_we_o = 1'b1;
                default:
                    regfile_we_o = 1'b0;
            endcase
        end
    end

    // mem_we_o处理
    always @(*) begin
        if(reset_i == 1'b1)
            mem_we_o = 1'b0;
        else begin
            case(opcode_i)
                // S型指令
                OPCODE_S:
                    mem_we_o = 1'b1;
                default:
                    mem_we_o = 1'b0;
            endcase
        end
    end

    // op_A_sel_o处理
    always @(*) begin
        case(opcode_i)
            // R型，I型，S型, B型
            OPCODE_R,
            OPCODE_I,
            OPCODE_LOAD,
            OPCODE_JAL,
            OPCODE_S,
            OPCODE_B:
                op_A_sel_o = 1'b1;
            default:
                op_A_sel_o = 1'b0;
        endcase
    end

    // op_B_sel_o
    always @(*) begin
        case(opcode_i)
            // R型，B型
            OPCODE_R,
            OPCODE_B:
                op_B_sel_o = 1'b1;
            default:
                op_B_sel_o = 1'b0;
        endcase
    end
    
    // alu_opcode_o处理
    always @(*) begin
        case(opcode_i)
            // R型，I型
            OPCODE_R,
            OPCODE_I: begin
                case(function3_i)
                    // 算术运算，加或减
                    3'b000: begin
                        // I型指令只有加
                        if(opcode_i == OPCODE_I)
                            alu_opcode_o = 5'b00000;
                        // R型指令根据f7第二高位判断加减
                        else
                            alu_opcode_o = (function7_i[5]==1'b0)?5'b00000:5'b00001;
                    end
                    // 逻辑运算
                    // AND操作
                    3'b111:
                        alu_opcode_o = 5'b01000;
                    // OR操作
                    3'b110:
                        alu_opcode_o = 5'b01001;
                    // XOR操作
                    3'b100:
                        alu_opcode_o = 5'b01010;
                    // 移位运算
                    // 左移
                    3'b001:
                        alu_opcode_o = 5'b01100;
                    // 右移,根据f7第二高位判断逻辑移位还是算术移位
                    3'b101:
                        alu_opcode_o = (function7_i[5]==1'b0)?5'b01101:5'b01110;
                    // 比较运算
                    // 有符号比较
                    3'b010:
                        alu_opcode_o = 5'b00100;
                    // 无符号比较
                    3'b011:
                        alu_opcode_o = 5'b00101;
                    default:;
                    endcase
            end
            // Load,Jalr,S
            OPCODE_LOAD,
            OPCODE_JAL,
            OPCODE_S:
                alu_opcode_o = 5'b00000;
            // B型
            OPCODE_B: begin
                case(function3_i)
                    3'b000: alu_opcode_o = 5'h0;
                    3'b001: alu_opcode_o = 5'h1;
                    3'b100: alu_opcode_o = 5'h3; 
                    3'b110: alu_opcode_o = 5'h2;
                    3'b101: alu_opcode_o = 5'h5;
                    3'b111: alu_opcode_o = 5'h4;
                    default:;
                endcase
            end
            // lui
            OPCODE_LUI:
                alu_opcode_o = 5'b10000;
            // auipc, jal
            OPCODE_AUIPC,
            OPCODE_JALR:
                alu_opcode_o = 5'b00000;
            default:;
        endcase
    end
    
    // mem_data_sel赋值
    always@(*) begin
        case(function3_i)
            3'b000: mem_data_sel_o = 2'b00;
            3'b001: mem_data_sel_o = 2'b01;
            3'b010: mem_data_sel_o = 2'b11;
            default:;
        endcase
    end

    // data_hazard_detet赋值
    always @(*) begin
        case(opcode_i)
            OPCODE_R, OPCODE_I, OPCODE_S, OPCODE_LOAD, OPCODE_S, OPCODE_B, OPCODE_JALR:
                data_hazard_detect_r1_o = 1'b1;
            default:
                data_hazard_detect_r1_o = 1'b0;
        endcase
    end

    always @(*) begin
        case(opcode_i)
            OPCODE_R, OPCODE_S, OPCODE_B:
                data_hazard_detect_r2_o = 1'b1;
            default:
                data_hazard_detect_r2_o = 1'b0;
        endcase
    end
endmodule
