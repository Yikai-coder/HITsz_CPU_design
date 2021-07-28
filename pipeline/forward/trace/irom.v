`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 15:21:18
// Design Name: 
// Module Name: irom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// irom模块，用于调用IP�?
// Dependencies: 
// prgrom
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module irom(
    input  [31:0] pc_i,
    output [31:0] inst_o
    );
    pgrom U0_irom(
        .a     (pc_i[15:2]),
        .spo   (inst_o)
    );
endmodule
