`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/27 17:31:10
// Design Name: 
// Module Name: instruction_fetch
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


module Ifetc32(
output[31:0] Instruction, // the instruction fetched from this module
output[31:0] branch_base_addr, // (pc+4) to ALU which is used by branch type instruction
input[31:0] Addr_result, // (pc+4) to decoder which is used by jal instruction
input[31:0] Read_data_1, // the address of instruction used by jr instruction
input Branch,// while Branch is 1,it means current instruction is beq
input nBranch, // while nBranch is 1,it means current instruction is bnq
input Jmp, // while Jmp 1,it means current instruction is jump
input Jal, // while Jal is 1,it means current instruction is jal
input Jr,
input Zero,
input clock,
input reset, // Clock and reset
// from ALU
output reg [31:0] link_addr,
output[31:0]pco//PC register
 // while Zero is 1, it means the ALUresult is zero
// from Decoder

// from controller

);



reg[31:0] PC,Next_PC;
assign branch_base_addr=PC+4;


progrom inst(
    .clka(clock),
    .addra(pco[15:2]),
    .douta(Instruction)
);

always @* begin
if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
    Next_PC = Addr_result; //Addr_result, next_pc_1
//else  if((Jmp == 1) || (Jal == 1))// next_pc_3
//        PC <= {4'b0000,Instruction[25:0],2'b00};
else if(Jr == 1)
    Next_PC[31:0] =Read_data_1;// Read_data_1*4,  next_pc_2
else
     Next_PC = PC+4>>2;// pc+4, shift right, because i shift it left in PC

end



always @(negedge clock) begin
if(reset == 1)
    PC <= 32'h0000_0000;
else begin
    if((Jmp == 1) || (Jal == 1))begin// next_pc_3
            PC <= {PC[31:28],Instruction[25:0],2'b00};
//        if(Jal)
           
    end
    else
        PC <=  Next_PC<<2;
    end
end

//output
assign pco=PC;

always @(posedge clock) begin
    if(Jal||Jmp)
        link_addr<=pco+4>>2; 
end


endmodule
