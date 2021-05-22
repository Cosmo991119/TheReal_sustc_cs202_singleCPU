`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 15:39:01
// Design Name: 
// Module Name: register
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
  
module Idecode32(
output [31:0] read_data_1,
output [31:0] read_data_2,
input [31:0] Instruction,//rs,rt,rd,address,immediate
input [31:0] read_data,//load data
input [31:0] ALU_result,//for operand
input Jal,
input RegWrite,
input MemtoReg,//load
input RegDst,//chose rt/rd as dest
output [31:0] imme_extend,//sign_extend
input clock,
input reset,
input [31:0] opcplus4 //for jal
    );
    
    wire[4:0] rs=Instruction[25:21];
    wire[4:0] rt=Instruction[20:16];
    wire[4:0] rd=Instruction[15:11];
    wire [15:0] immediate=Instruction[15:0];
    
    reg [4:0] write_reg_input;
    reg [31:0] write_data_input;
    
    always @(*) begin
    if(Jal) begin
        write_reg_input = 5'd31;
    end else if(RegDst) begin
        write_reg_input = rd;
    end else begin
        write_reg_input = rt;
    end
    end
    
    always @(*) begin
    if(Jal) begin
        write_data_input = opcplus4;
    end else if(MemtoReg) begin
        write_data_input = read_data;
    end else begin
        write_data_input = ALU_result;
    end
    end
    
    //register 32*32
    reg[31:0] data[31:0];

    always @(posedge clock) begin
    if(reset) begin
       // assign data[0]={32'b0};
        data[0] <= 32'b0;
        data[1] <= 32'b0;
        data[2] <= 32'b0;
        data[3] <= 32'b0;
        data[4] <= 32'b0;
        data[5] <= 32'b0;
        data[6] <= 32'b0;
        data[7] <= 32'b0;
        data[8] <= 32'b0;
        data[9] <= 32'b0;
        data[10] <= 32'b0;
        data[11] <= 32'b0;
        data[12] <= 32'b0;
        data[13] <= 32'b0;
        data[14] <= 32'b0;
        data[15] <= 32'b0;
        data[16] <= 32'b0;
        data[17] <= 32'b0;
        data[18] <= 32'b0;
        data[19] <= 32'b0;
        data[20] <= 32'b0;
        data[21] <= 32'b0;
        data[22] <= 32'b0;
        data[23] <= 32'b0;
        data[24] <= 32'b0;
        data[25] <= 32'b0;
        data[26] <= 32'b0;
        data[27] <= 32'b0;
        data[28] <= 32'b0;
        data[29] <= 32'b0;
        data[30] <= 32'b0;
        data[31] <= 32'b0;
    end
    else begin
        if( RegWrite) begin
            data[write_reg_input] <= write_data_input;
        end
      
    end
    end
    
    assign read_data_1=data[rs];
    assign read_data_2=data[rt];

    
assign imme_extend = {{16{immediate[15]}}, immediate};
    
endmodule
