`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 22:48:04
// Design Name: 
// Module Name: controller
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


module control32plus(
    //page 3
    input [5:0] Opcode,
    input [5:0] Function_opcode,//page 5
    output Jr,
    output RegDST,
    output ALUSrc,
    output MemorIOtoReg,// MemtoReg,
    output RegWrite,
    output MemWrite,
    output Branch,
    output nBranch,
    output Jmp,
    output Jal,
    output I_format,
    output Sftmd,
    output[1:0] ALUOp,
    
    //control+
    input[21:0] Alu_resultHigh,
    output MemRead,
    output IORead,
    output IOWrite
    

    );
    
    //chose instruction type, 000000, jr&jal&hmp, otherwise, page 6/5

    assign Jr=((Function_opcode==6'b00_1000)&&(Opcode==6'b00_0000))? 1'b1 : 1'b0;
    
    wire R_format=(Opcode==6'b00_0000)? 1'b1:1'b0;
    assign I_format=(Opcode[5:3]==3'b001)?1'b1:1'b0;
    assign RegDST=R_format;
    wire J_format=~(R_format||I_format);
    assign Jmp=((Opcode==6'b00_0010) && J_format)?1'b1:1'b0;
    assign Jal=((Opcode==6'b00_0011)&& J_format)?1'b1:1'b0;
    
    assign Branch=(Opcode==6'b00_0100)?1'b1:1'b0;
    assign nBranch=(Opcode==6'b00_0101)?1'b1:1'b0;
    
    wire lw=(Opcode==6'b10_0011)?1'b1:1'b0;
    wire sw=(Opcode==6'b10_1011)?1'b1:1'b0;
    
    
    assign MemWrite=(sw && (Alu_resultHigh[21:0]==22'h3FFFFF))?1'b1:1'b0;
    assign MemRead=(lw &&(Alu_resultHigh[21:0]==22'h3FFFFF) );
    assign IORead=(lw &&(Alu_resultHigh[21:0]!=22'h3FFFFF) );//guess
    assign IOWrite=(sw &&(Alu_resultHigh[21:0]!=22'h3FFFFF) );
    
    assign RegWrite=(R_format||lw||Jal||I_format)&& !(Jr); 
    assign ALUOp={(R_format||I_format),(Branch || nBranch)};
    assign Sftmd=(((Function_opcode==6'b000000)||(Function_opcode==6'b000010)||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))&& R_format)?1'b1:1'b0;
    
    assign ALUSrc=(I_format || Opcode[5:4]==2'b10); 
    assign MemorIOtoReg=(IORead||MemRead);
    
    
    
endmodule
