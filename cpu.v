`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 15:21:11
// Design Name: 
// Module Name: cpu
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


module cpu(
    input clk,
    input rst,
    input[23:0] switch_in,
    output[23:0] led_out
    );
    
    //clock IP 
    wire clock;
    
    cpuclk cpuclk_inst(
        .clk_in1(clk),
        .clk_out1(clock)
    );
    
    //IF
//    wire[23:0] reout=switch_in;
//    assign switch_reout=reout;
    
    wire[31:0] Instruction;            
    wire[31:0] branch_base_addr;
    wire[31:0] link_addr;
    wire[31:0] pco;
    
    wire[31:0] Addr_result; // (pc+4) to decoder which is used by jal instruction
    wire[31:0] Read_data_1; // the address of instruction used by jr instruction
    wire Branch;// while Branch is 1,it means current instruction is beq
    wire nBranch; // while nBranch is 1,it means current instruction is bnq
    wire Jmp; // while Jmp 1,it means current instruction is jump
    wire Jal; // while Jal is 1,it means current instruction is jal
    wire Jr;
    wire Zero;
    wire reset=rst; // Clock and reset

Ifetc32 IFetch(
     Instruction, // the instruction fetched from this module
     branch_base_addr, // (pc+4) to ALU which is used by branch type instruction
     Addr_result, // (pc+4) to decoder which is used by jal instruction
     Read_data_1, // the address of instruction used by jr instruction
     Branch,// while Branch is 1,it means current instruction is beq
     nBranch, // while nBranch is 1,it means current instruction is bnq
     Jmp, // while Jmp 1,it means current instruction is jump
     Jal, // while Jal is 1,it means current instruction is jal
     Jr,
     Zero,
     clock,
     reset, // Clock and reset
// from ALU
     link_addr,
     pco//PC register
);
 

//controller
    wire[5:0] Opcode=Instruction[31:26];//see picture of lab9
    wire[5:0] Function_opcode=Instruction[5:0]; //format fo instruction    
    //output

    wire RegDST;
    wire ALUSrc;
    wire RegWrite;
    wire MemWrite;
    wire I_format;
    wire Sftmd;
    wire[1:0] ALUOp;

    
//controll_plus
    wire[31:0] ALU_result;
    wire[21:0] Alu_resultHigh=ALU_result[31:10];// From the execution unit Alu_Result[31..10]
    wire MemorIOtoReg;
    wire MemRead;
    wire IORead;
    wire IOWrite;
    
    
        //output 
   wire[31:0] Read_data_2;
   wire [31:0] imme_extend;//sign_extend
   wire[31:0] read_data;

       
control32plus controller(
    //page 3
     Opcode,
     Function_opcode,//page 5
     Jr,
     RegDST,
     ALUSrc,
     MemorIOtoReg,
     RegWrite,
     MemWrite,
     Branch,
     nBranch,
     Jmp,
     Jal,
     I_format,
     Sftmd,
     ALUOp,
     Alu_resultHigh,
     MemRead,
     IORead,
     IOWrite
    );
  
 
//decoder

   
Idecode32 decoder(
     Read_data_1,
     Read_data_2,
     Instruction,//rs,rt,rd,address,immediate
     read_data,//load data
     ALU_result,//for operand
     Jal,
     RegWrite,
     MemorIOtoReg,//load
     RegDST,//chose rt/rd as dest
     imme_extend,//sign_extend
     clock,
     reset,
     pco-4>>2 //for jal
);

//ALU
    //input
    wire[4:0] Shamt=Instruction[10:6];//check the instruction define
Executs32 ALU(
    //decoder
     Read_data_1,
     Read_data_2,
     imme_extend,
    //ifetch
     Function_opcode,
     Opcode,
     ALUOp,
     Shamt,
     ALUSrc,
     I_format,
     Zero,
     Sftmd,
     ALU_result,
     Addr_result,
     branch_base_addr,
     Jr
    );
    

//memory_IO

//output
wire SwitchCtrl;
wire LEDCtrl;
wire[31:0] write_data;
wire[31:0] addr_out;
wire[31:0] r_wdata;
wire[31:0] m_rdata;
wire[31:0] io_rdata;

MemoryOrIO memory_or_io(
    addr_out,//address
    
    ALU_result,//addr_in
    
     MemRead, 
     MemWrite, 
     IORead, //from control+
     IOWrite,//from control+
     
     //these signal from memory
     m_rdata, 
     io_rdata, 
     Read_data_2,//r_rdata
     read_data, //r_wdata,data to decoder  
     write_data, 
     LEDCtrl, 
     SwitchCtrl); 
     
     //led
     wire[1:0] led_addr=addr_out[1:0];
     leds leds_inst(
         clock,
         reset, 
         IOWrite,
         LEDCtrl,
         
         led_addr,
         write_data,
         led_out
     );
     
     //switch
     wire[1:0]  switch_adrr=addr_out[1:0];
     switchs switchs_inst(
         clock,
         reset,
         IORead,
         SwitchCtrl,
         switch_adrr,
         io_rdata,
         switch_in
     );

     //dmemory32
     dmemory32 memory(
          m_rdata,
          addr_out,
          write_data,
          MemWrite,
          clock
     );
   
endmodule

