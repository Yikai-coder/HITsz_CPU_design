`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/08 14:10:06
// Design Name: 
// Module Name: top
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


module top(
    input       clk_i,
    input       rst_i,
    output wire led0_en,
    output wire led1_en,
    output wire led2_en,
    output wire led3_en,
    output wire led4_en,
    output wire led5_en,
    output wire led6_en,
    output wire led7_en,
    output wire led_ca ,
    output wire led_cb ,
    output wire led_cc ,
    output wire led_cd ,
    output wire led_ce ,
    output wire led_cf ,
    output wire led_cg ,
    output wire led_dp
    );
    wire [31:0] rD19;
    wire clk_display;
    wire rst_n = ~rst_i;
    my_cpu u_my_cpu(
       .sysclk_i(clk_i),         
       .reset_i (rst_i),
       .rD19_o  (rD19)
    );
    clock_divider u_clock_divider(
        .clk(clk_i),
        .out(clk_display)
    );
    display u_display(
        .clk  (clk_display),  
        .rst_n(rst_n),  
        .busy (1'b0),  
        .z1   (rD19[31:24]),  
        .r1   (rD19[23:16]),  
        .z2   (rD19[15:8]),  
        .r2   (rD19[7:0]),
        .led0_en(led0_en),
        .led1_en(led1_en),
        .led2_en(led2_en),
        .led3_en(led3_en),
        .led4_en(led4_en),
        .led5_en(led5_en),
        .led6_en(led6_en),
        .led7_en(led7_en),
        .led_ca (led_ca), 
        .led_cb (led_cb), 
        .led_cc (led_cc), 
        .led_cd (led_cd), 
        .led_ce (led_ce), 
        .led_cf (led_cf), 
        .led_cg (led_cg), 
        .led_dp (led_dp)  
    );

endmodule
