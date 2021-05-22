`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 23:43:40
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb();
reg clk;
reg rst;
reg[23:0] switch_in=24'h000000;
wire[23:0] led_out;
cpu c(clk,rst,switch_in,led_out);

initial begin
clk=1'b0;
rst=1;
#7000 rst=0;
//#100 switch_in[23:21]=3'b001;switch_in[15:0]=16'h0001;
//#100 rst = 0;
//#100 switch_in[23:21]=3'b001;
//#100 switch_in[23:21]=3'b010;
//#100 switch_in[23:21]=3'b011;
//#100 switch_in[23:21]=3'b100;
//#100 switch_in[23:21]=3'b101;
//#100 switch_in[23:21]=3'b110;
end // r_rdata -> m_wdata(write_data) 

always #10 clk=~clk;



endmodule
