`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 20:48:39
// Design Name: 
// Module Name: memory
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


module dmemory32(readData,address,writeData,memWirte,clock);
input clock;
input[31:0] address;
input memWirte;
input[31:0] writeData;
output[31:0] readData;

assign clk=!clock;

//RAM
RAM ram(
    .clka(clk),
    .wea(memWrite),
    .addra(address[15:2]),
    .dina(writeData),
    .douta(readData)
);
endmodule
