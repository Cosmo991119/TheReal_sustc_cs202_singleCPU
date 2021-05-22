`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 12:48:13
// Design Name: 
// Module Name: dmemory32
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

module dmemory32(
output[31:0] read_data,
input[31:0] address,
input[31:0] write_data,
input Memwrite,
input clock
);

wire clk;

assign clk=!clock;

//RAM
RAM ram(
    .clka(clk),
    .wea(Memwrite),
    .addra(address[15:2]),
    .dina(write_data),
    .douta(read_data)
);
endmodule

