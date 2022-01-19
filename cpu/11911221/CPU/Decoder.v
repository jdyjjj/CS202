`timescale 1ns / 1ps

module Decoder(read_data_1,read_data_2,Instruction,read_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,imme_extend,clock,reset, opcplus4);
    output[31:0]  read_data_1;               
    output[31:0]  read_data_2;               
    input[31:0]  Instruction;              
    input[31:0]  read_data;   				
    input[31:0]  ALU_result;   				
    input        Jal;             
    input        RegWrite;            
    input        MemtoReg;             
    input        RegDst;               
    output[31:0] imme_extend;            
    input		 clock;                 
    input        reset;             
    input[31:0]  opcplus4;              
    
    wire[31:0] read_data_1;
    wire[31:0] read_data_2;
    reg[31:0] register[0:31];			   
    reg[4:0] write_register_address;      
    reg[31:0] write_data;                 

    wire[4:0] rs;    
    wire[4:0] rt;    
    wire[4:0] rd;   
    wire[4:0] rt_i;   
    wire[5:0] op;                    
    
    assign op = Instruction[31:26];	
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];

    wire[15:0] immediate = Instruction[15:0];
    assign imme_extend = {{16{immediate[15]}}, immediate};

    
    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];


    always @*
    begin
        if(Jal == 1'b1)
        write_register_address <= 32'd31;
        if(RegDst == 1'b0&&Jal == 1'b0)
        write_register_address <= rt;
        else if(RegDst == 1'b1)
        write_register_address <= rd;
    end

    always @*
    begin 
        if (6'b000011 == op && 1'b1 == Jal) begin
           write_data = opcplus4;
        end
        else if(1'b0 == MemtoReg) begin
                write_data = ALU_result;
        end 
        else begin
            write_data = read_data;
        end    
    end

    always @(posedge clock) begin       
        if(reset==1) begin             
           register[0] <= 0;
           register[1] <= 0;
           register[2] <= 0;
           register[3] <= 0;
           register[4] <= 0;
           register[5] <= 0;
           register[6] <= 0;
           register[7] <= 0;
           register[8] <= 0;
           register[9] <= 0;
           register[10] <= 0;
           register[11] <= 0;
           register[12] <= 0;
           register[13] <= 0;
           register[14] <= 0;
           register[15] <= 0;
           register[16] <= 0;
           register[17] <= 0;
           register[18] <= 0;
           register[19] <= 0;
           register[20] <= 0;
           register[21] <= 0;
           register[22] <= 0;
           register[23] <= 0;
           register[24] <= 0;
           register[25] <= 0;
           register[26] <= 0;
           register[27] <= 0;
           register[28] <= 0;
           register[29] <= 0;
           register[30] <= 0;
           register[31] <= 0;
           
        end 
        else if(RegWrite==1&&write_register_address != 0) begin                   
                register[write_register_address] <= write_data;    
        end
    end
endmodule
