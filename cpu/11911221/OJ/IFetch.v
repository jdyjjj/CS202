`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module IFetch(Instruction,pco,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,branch_base_addr);
    
    output[31:0] pco;         // (pc+4)送执行单元 pco
    input[31:0]  Addr_result;            // 来自执行单元,算出的跳转地址 1
    input[31:0]  Read_data_1;           // 来自译码单元，jr指令用的地址 2
    input        Branch;                // 来自控制单元 2
    input        nBranch;               // 来自控制单元 2
    input        Jmp;                   // 来自控制单元 2
    input        Jal;                   // 来自控制单元 2
    input        Jr;                   // 来自控制单元 2
    input        Zero;                  //来自执行单元 2
    input        clock;           //时钟与复位 3
    input        reset;           //时钟与复位 3
    output[31:0] Instruction;			// 输出指令到其他模块 1
    output[31:0] link_addr;              // JAL指令专用的PC+4  link_addr;
    output [31:0] branch_base_addr;              //branch_base_addr
    //branch_base_addr = pco+4

    wire[31:0]   PC_plus_4;             // PC+4
    reg[31:0]	  PC;                   // PC寄存器
    reg[31:0]    link_addr;
    reg [31:0]  next_PC;
    
   //分配64KB ROM，编译器实际只用 64KB ROM
    prgrom instmem(
        .clka(clock),         // input wire clka
        .addra(PC[15:2]),     // input wire [13 : 0] addra
        .douta(Instruction)         // output wire [31 : 0] douta
    );
    assign pco = PC;
   assign PC_plus_4[31:2] = PC[31:2] + 1'b1;
   assign PC_plus_4[1:0] =PC[1:0];
   assign branch_base_addr = PC_plus_4;
    
    always @(*) begin
    if(((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0)))
        next_PC = Addr_result;
    else if((nBranch == 1) && (Zero == 0))
         next_PC = Addr_result;
    else if(Jr == 1)   
        next_PC = Read_data_1;
    else
        next_PC = branch_base_addr >> 2;
end

always @(negedge clock) 
begin
    if(reset == 1)   
        PC <= 32'h0000_0000;
    else
    begin
        if( (Jmp == 1))   
        begin
            link_addr = next_PC;                                
            PC <= {4'b0000, Instruction[25:0], 2'b00};
        end
        else if (Jal == 1)
             begin
               link_addr = next_PC;                                
               PC <= {4'b0000, Instruction[25:0], 2'b00};
           end
        else 
            PC <= next_PC << 2;
    end
end

endmodule