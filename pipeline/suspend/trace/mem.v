`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:19:18
// Design Name: 
// Module Name: dram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 访存模块，用于与dram交互并处理输入输出的数据
// Dependencies: 
// dram
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module mem(
    input             clk_i,
    input             we_i,
    input      [15:0] adr_i,
    output     [13:0] adr_o,
    input      [31:0] wd_i,
    input             reset_i,
    input      [1:0]  mem_data_sel_i,
    output reg [31:0] mem_data_o,             // mem模块输出
    input      [31:0] test_outerram_data_i,   // 外部ram的输出数据，传�?�至mem进行处理
    output     [31:0] test_outerram_data_o    // 外部ram的输入数据，传�?�至mem进行处理
    );
    wire ram_clk;
    assign ram_clk = !clk_i; 
    // 直接与dram相连的信号线
    reg  [31:0] dram_input;
    wire [31:0] dram_output;
    // 保持代码统一，将外部送入的数据连接到dram_output，处理同本模块中的dram输出
    assign dram_output = test_outerram_data_i;
    assign adr_o = adr_i[15:2];
    // 记录输入和输出信号的不同字节
    wire [7:0]  dram_output_0     = dram_output[7:0];
    wire [7:0]  dram_output_1     = dram_output[15:8];
    wire [7:0]  dram_output_2     = dram_output[23:16];
    wire [7:0]  dram_output_3     = dram_output[31:24];
    reg  [7:0]  dram_output_byte;
    reg  [15:0] dram_output_word;
    wire [31:0] dram_output_dword = dram_output;
    wire [7:0]  dram_input_byte   = wd_i[7:0];
    wire [15:0] dram_input_word   = wd_i[15:0];
    wire [31:0] dram_input_dword  = wd_i;

    // 根据地址低两位确定lb时读取的字节
    always @(*) begin
        case(adr_i[1:0])
            2'b00: dram_output_byte = dram_output_0;
            2'b01: dram_output_byte = dram_output_1;
            2'b10: dram_output_byte = dram_output_2;
            2'b11: dram_output_byte = dram_output_3;
            default:;
        endcase
    end

    // 根据地址第二位确定lw时读取的�?
    always @(*) begin
        // 选择高字
        if(adr_i[1])
            dram_output_word = {dram_output_3, dram_output_2};
        // 选择低字
        else
            dram_output_word = {dram_output_1, dram_output_0};
    end
    // 输出数据处理
    always @(*) begin
        case(mem_data_sel_i)
            2'b00: mem_data_o = {{24{dram_output_byte[7]}}, dram_output_byte};  // lb
            2'b01: mem_data_o = {{16{dram_output_word[15]}}, dram_output_word};  // lh
            2'b11: mem_data_o = dram_output_dword;    // lw
            default:;
        endcase
    end
    // dram输入数据处理
    always @(*) begin
        case(mem_data_sel_i)
            // sb
            2'b00: begin
                case(adr_i[1:0])
                    2'b00: dram_input = {{24{dram_input_byte[7]}}, dram_input_byte};
                    2'b01: dram_input = {{16{dram_input_byte[7]}}, dram_input_byte, 8'h0};
                    2'b10: dram_input = {{8{dram_input_byte[7]}}, dram_input_byte, 16'h0};
                    2'b11: dram_input = {dram_input_byte, 24'h0};
                    default:;
                endcase
            end
            // sh
            2'b01: begin
                case(adr_i[1])
                    1'b0: dram_input = {{16{dram_input_word[15]}}, dram_input_word};
                    1'b1: dram_input = {dram_input_word, 16'h0};
                    default:;
                endcase 
            end 
            2'b11: dram_input = dram_input_dword;    // lw
            default:;
        endcase
    end
    assign test_outerram_data_o = dram_input; // test
    // // 64KB DRAM
    // dram U_dram (
    //     .clk    (clk_i),            // input wire clka
    //     .a      (adr_i[15:2]),     // input wire [13:0] addra
    //     .spo   (dram_output),        // output wire [31:0] douta
    //     .we     (we_i),          // input wire [0:0] wea
    //     .d      (dram_input)         // input wire [31:0] dina
    // );
endmodule
