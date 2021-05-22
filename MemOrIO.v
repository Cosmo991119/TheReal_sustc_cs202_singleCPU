`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 21:17:25
// Design Name: 
// Module Name: MemOrIO
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


module MemoryOrIO(  addr_out,addr_in, mRead, mWrite, ioRead, ioWrite,
m_rdata, io_rdata, r_rdata, r_wdata,  write_data, LEDCtrl, SwitchCtrl); 
input mRead; 
// read memory, from control32 
input mWrite; 
// write memory, from control32 
input ioRead; 
// read IO, from control32 
input ioWrite; 
// write IO, from control32 
input[31:0] addr_in; 
// from alu_result in executs32 
output[31:0] addr_out; 
// address to memory 
input[31:0] m_rdata; 
// data read from memory 
input[15:0] io_rdata; 
// data read from io,16 bits 
output reg[31:0] r_wdata; 
// data to idecode32(register file) 
input[31:0] r_rdata; 
// data read from idecode32(register file) 
output reg[31:0] write_data; 
// data to memory or I/O??m_wdata, io_wdata?? 
output LEDCtrl; 
// LED Chip Select 
output SwitchCtrl; 
// Switch Chip Select
assign addr_out= addr_in; 
 
always @* begin
    if(ioRead)// While the data is from io, it should be the lower 16bit of r_wdata
        r_wdata = io_rdata;
    else if(mRead) // The data wirte to register file may be from memory or io. 
        r_wdata=m_rdata;
    else
        r_wdata= 32'hZZZZZZZZ;          
end

// Chip select signal of Led and Switch are all active high; 
assign LEDCtrl=ioWrite;
assign SwitchCtrl=ioRead; 
always @* begin 
if((mWrite==1)||(ioWrite==1)) 
//wirte_data could go to either memory or IO. where is it from? 
write_data = r_rdata;
else 
write_data = 32'hZZZZZZZZ; 
end 
endmodule 
