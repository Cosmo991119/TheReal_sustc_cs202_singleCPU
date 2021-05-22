`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/01 00:25:03
// Design Name: 
// Module Name: ALU
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


module Executs32(
    //decoder
    input[31:0] Read_data_1,
    input[31:0] Read_data_2,
    input[31:0] Imme_extend,
    //ifetch
    input[5:0] Function_opcode,
    input[5:0] opcode,
    input[1:0] ALUOp,
    input[4:0] Shamt,
    input ALUSrc,
    input I_format,
    output reg Zero,
    input Sftmd,
    output reg[31:0] ALU_Result,
    output reg[31:0] Addr_Result,
    input[31:0] PC_plus_4,
    input Jr
    );
    
    wire[31:0] Ainput,Binput;// data1, data2 ? imme_extend
    wire[5:0] Exe_code;
    wire[2:0] ALU_ctl;
    wire[2:0] Sftm;
    
    reg[31:0] ALU_output_mux;
    reg[31:0] Shift_Result;
    wire[32:0] Branch_Addr;
    
    assign Ainput=Read_data_1;
    assign Binput=(ALUSrc==0)?Read_data_2:Imme_extend[31:0];
  
    assign Exe_code = (I_format==0) ? Function_opcode : { 3'b000 , opcode[2:0] };
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000:ALU_output_mux= Ainput & Binput;
            3'b001:ALU_output_mux= Ainput | Binput ;
            3'b010:ALU_output_mux= Ainput + Binput;//add
            3'b011:ALU_output_mux= Ainput +Binput;//addu
            3'b100:ALU_output_mux= Ainput ^ Binput;
            3'b101:ALU_output_mux=~( Ainput | Binput);//nor
            3'b110:ALU_output_mux= Ainput - Binput;//sub,bneq,beq    rd is addr_result 
            3'b111:ALU_output_mux= Ainput - Binput;//slt or subu,sltu
            default:ALU_output_mux=32'h0000_0000;
        endcase
    end
    
    assign Sftm=Function_opcode[2:0];
    wire signed [31:0] signedBinput = Binput;
    wire signed [31:0] signedAinput = Ainput;
    wire signed[31:0] answer=signedAinput-signedBinput;
    wire[4:0] sll_bit=Ainput[4:0];
 
    always @* begin // six types of shift instructions
    if(Sftmd)
        case(Sftm[2:0])
            3'b000:Shift_Result = Binput << Shamt; //Sll rd,rt,shamt 00000
            3'b010:Shift_Result = Binput >> Shamt; //Srl rd,rt,shamt 00010
            3'b100:Shift_Result = Binput << sll_bit; //Sllv rd,rt,rs 000100
            3'b110:Shift_Result = Binput >> sll_bit; //Srlv rd,rt,rs 000110
            3'b011:Shift_Result = signedBinput >>> Shamt; //Sra rd,rt,shamt 00011
            3'b111:Shift_Result = signedBinput >>> Ainput; //Srav rd,rt,rs 00111
        default:Shift_Result = Binput;
        endcase
    else
        Shift_Result = Binput;
    end
    
    
    always @* begin
    //set type operation (slt, slti, sltu, sltiu)

        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) begin
            ALU_Result=(Ainput -Binput <0)?1:0;
             if(Exe_code[1:0]==2'b10)begin//slt
                 ALU_Result=((answer)<0)?1:0;   
                 if(answer[31]==0)
                     Zero= (ALU_Result!=0);
                 else
                     Zero= (ALU_Result==0);              
                end  
             else
                Zero= (ALU_Result==0);   
        end
    //lui operation
        else if((ALU_ctl==3'b101) && (I_format==1)) begin
            ALU_Result[31:0]={Binput[15:0],{16{1'b0}}};
             Zero= (ALU_Result==0);
             end
    //shift operation
        else if(Sftmd==1) begin
            ALU_Result = Shift_Result ;
            if(Sftm==3'b100)
                Zero=1'b1;
            else
               Zero=(ALU_Result==0);     
            end
    //other types of operation in ALU (arithmatic or logic calculation)
        else begin
            ALU_Result = ALU_output_mux;
             Zero= (ALU_Result==0);
             end
    end

    
//    always @* begin
//        if(answer[31]==0)
//            Zero= ALU_Result;
//        else
//            Zero= (ALU_Result==0);
//    end
    
    always @* begin
            Addr_Result=(PC_plus_4>>2)+Imme_extend;
    end
 
endmodule
