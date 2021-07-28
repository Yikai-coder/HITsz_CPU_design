`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 14:22:58
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 寄存器堆模块的子模块，每个模块存储8个寄存器
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module reg_file_8(
    input             clk_i,
    input             reset_i,
    input      [4:0]  rR1_i,
    input      [4:0]  rR2_i,
    input      [4:0]  wR_i, 
    input      [31:0] wD_i,
    input             WE_i,
    output reg [31:0] rD1_o,
    output reg [31:0] rD2_o
);
    reg [31:0] reg_0;
    reg [31:0] reg_1;
    reg [31:0] reg_2;
    reg [31:0] reg_3;
    reg [31:0] reg_4;
    reg [31:0] reg_5;
    reg [31:0] reg_6;
    reg [31:0] reg_7;
    // rD1_o
    always @ (*) begin
        case(rR1_i[2:0]) 
            3'b000: rD1_o = (rR1_i[4:3]==2'b00)?32'h0:reg_0;   // x0不可被修改
            3'b001: rD1_o = reg_1; 
            3'b010: rD1_o = reg_2;
            3'b011: rD1_o = reg_3;
            3'b100: rD1_o = reg_4;
            3'b101: rD1_o = reg_5;
            3'b110: rD1_o = reg_6;
            3'b111: rD1_o = reg_7;
            default: rD1_o = 32'h0;
        endcase
    end
    // rD2_o
    always @ (*) begin
        case(rR2_i[2:0]) 
            3'b000: rD2_o = (rR2_i[4:3]==2'b00)?32'h0:reg_0;
            3'b001: rD2_o = reg_1; 
            3'b010: rD2_o = reg_2;
            3'b011: rD2_o = reg_3;
            3'b100: rD2_o = reg_4;
            3'b101: rD2_o = reg_5;
            3'b110: rD2_o = reg_6;
            3'b111: rD2_o = reg_7;
            default: rD2_o = 32'h0;
        endcase
    end
    // wirte
    always @ (posedge clk_i or posedge reset_i) begin
        if(reset_i == 1'b1) begin
            reg_0 = 32'h0;
            reg_1 = 32'h0;
            reg_2 = 32'h0;
            reg_3 = 32'h0;
            reg_4 = 32'h0;
            reg_5 = 32'h0;
            reg_6 = 32'h0;
            reg_7 = 32'h0;
        end
        else
            if(WE_i == 1'b1) begin
                case(wR_i[2:0]) 
                    3'b000: reg_0 = (wR_i[4:3]==2'b00)?32'h0:wD_i;
                    3'b001: reg_1 = wD_i; 
                    3'b010: reg_2 = wD_i;
                    3'b011: reg_3 = wD_i;
                    3'b100: reg_4 = wD_i;
                    3'b101: reg_5 = wD_i;
                    3'b110: reg_6 = wD_i;
                    3'b111: reg_7 = wD_i;
                    default:; 
                endcase
            end
            else;
    end
endmodule
