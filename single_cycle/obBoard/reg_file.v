`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 16:01:34
// Design Name: 
// Module Name: reg_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 寄存器堆模块
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module reg_file(    
    input             clk_i,
    input             reset_i,
    input [4:0]       rR1_i,
    input [4:0]       rR2_i,
    input [4:0]       wR_i,
    input [31:0]      wD_i,
    input             WE_i,
    output reg [31:0] rD1_o,
    output reg [31:0] rD2_o,
    output     [31:0] rD19_o
    );
    reg         WE_0;
    reg         WE_1;
    reg         WE_2;
    reg         WE_3;
    wire [31:0] rD1_0;
    wire [31:0] rD1_1;
    wire [31:0] rD1_2;
    wire [31:0] rD1_3;
    wire [31:0] rD2_0;
    wire [31:0] rD2_1;
    wire [31:0] rD2_2;
    wire [31:0] rD2_3; 
    reg         first_time;

    always @(posedge clk_i or posedge reset_i) begin
        if(reset_i)
            first_time <= 1'b0;
        else
            first_time <= 1'b1;
    end 
    always@(*) begin
        case(wR_i[4:3])
        2'b00:begin
            WE_0 = first_time & WE_i & 1'b1;
            WE_1 = first_time & WE_i & 1'b0;
            WE_2 = first_time & WE_i & 1'b0;
            WE_3 = first_time & WE_i & 1'b0;
        end
        2'b01:begin
            WE_0 = first_time & WE_i & 1'b0;
            WE_1 = first_time & WE_i & 1'b1;
            WE_2 = first_time & WE_i & 1'b0;
            WE_3 = first_time & WE_i & 1'b0;        
        end
        2'b10:begin
            WE_0 = first_time & WE_i & 1'b0;
            WE_1 = first_time & WE_i & 1'b0;
            WE_2 = first_time & WE_i & 1'b1;
            WE_3 = first_time & WE_i & 1'b0;        
        end
        2'b11:begin
            WE_0 = first_time & WE_i & 1'b0;
            WE_1 = first_time & WE_i & 1'b0;
            WE_2 = first_time & WE_i & 1'b0;
            WE_3 = first_time & WE_i & 1'b1;
        end
        default:begin
            WE_0 = 1'b0;
            WE_1 = 1'b0;
            WE_2 = 1'b0;
            WE_3 = 1'b0;
        end
        endcase
    end
    reg_file_8 u_reg_file_8_0(
        .clk_i  (clk_i),
        .reset_i(reset_i),
        .rR1_i  (rR1_i),
        .rR2_i  (rR2_i),
        .wR_i   (wR_i[2:0]),
        .wD_i   (wD_i),
        .WE_i   (WE_0),
        .rD1_o  (rD1_0),
        .rD2_o  (rD2_0)
    );
    reg_file_8 u_reg_file_8_1(
        .clk_i  (clk_i),
        .reset_i(reset_i),
        .rR1_i  (rR1_i),
        .rR2_i  (rR2_i),
        .wR_i   (wR_i[2:0]),
        .wD_i   (wD_i),
        .WE_i   (WE_1),
        .rD1_o  (rD1_1),
        .rD2_o  (rD2_1)
    );    
    reg_file_8 u_reg_file_8_2(
        .clk_i  (clk_i),
        .reset_i(reset_i),
        .rR1_i  (rR1_i),
        .rR2_i  (rR2_i),
        .wR_i   (wR_i[2:0]),
        .wD_i   (wD_i),
        .WE_i   (WE_2),
        .rD1_o  (rD1_2),
        .rD2_o  (rD2_2),
        .rD19_o (rD19_o)
    );    
    reg_file_8 u_reg_file_8_3(
        .clk_i  (clk_i),
        .reset_i(reset_i),
        .rR1_i  (rR1_i),
        .rR2_i  (rR2_i),
        .wR_i   (wR_i[2:0]),
        .wD_i   (wD_i),
        .WE_i   (WE_3),
        .rD1_o  (rD1_3),
        .rD2_o  (rD2_3)
    );
    // 对4个reg_file_8的输出做选择
    always@(*) begin
        if(reset_i == 1'b1)
            rD1_o = 32'h0;
        else begin
            case(rR1_i[4:3])
            2'b00:begin
                rD1_o = rD1_0;
            end
            2'b01:begin
                rD1_o = rD1_1;
            end
            2'b10:begin
                rD1_o = rD1_2;
            end
            2'b11:begin
                rD1_o = rD1_3;
            end
            default:;
            endcase
        end
    end
    // 对4个reg_file_8的输出做选择
    always@(*) begin
        if(reset_i == 1'b1)
            rD2_o = 32'h0;
        else begin
            case(rR2_i[4:3])
            2'b00:begin
                rD2_o = rD2_0;
            end
            2'b01:begin
                rD2_o = rD2_1;
            end
            2'b10:begin
                rD2_o = rD2_2;
            end
            2'b11:begin
                rD2_o = rD2_3;
            end
            default:;
            endcase
        end
    end
endmodule
