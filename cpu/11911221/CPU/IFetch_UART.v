`timescale 1ns / 1ps

module IFetch_UART(Instruction,pco,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,branch_base_addr,
               upg_rst_i,upg_clk_i,upg_wen_i,upg_adr_i,upg_dat_i,upg_done_i);
    
    output[31:0] pco;
    input[31:0]  Addr_result;
    input[31:0]  Read_data_1;
    input        Branch;
    input        nBranch;
    input        Jmp;
    input        Jal;
    input        Jr;
    input        Zero;
    input        clock;
    input        reset;
    output[31:0] Instruction;
    output[31:0] link_addr;
    output [31:0] branch_base_addr;

    input upg_rst_i;
    input upg_clk_i;
    input upg_wen_i;
    input[13:0] upg_adr_i;
    input[31:0] upg_dat_i;
    input upg_done_i;

    wire[31:0]   PC_plus_4;
    reg[31:0]	  PC;
    reg[31:0]    link_addr;
    reg [31:0]  next_PC;

    wire kickOff = upg_rst_i|(~upg_rst_i&upg_done_i);
    
    prgrom instmem(
        .clka(kickOff?clock:upg_clk_i),
        .wea(kickOff?1'b0:upg_wen_i),
        .addra(kickOff?PC[15:2]:upg_adr_i),
        .dina(kickOff?32'h00000000:upg_dat_i),
        .douta(Instruction)
    );
   assign pco = PC;
   assign PC_plus_4[31:2] = PC[31:2] + 1'b1;
   assign PC_plus_4[1:0] =PC[1:0];
   assign branch_base_addr = PC_plus_4;
    
    always @* begin
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