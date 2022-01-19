module ALU(
    input[31:0]      Read_data_1, //the source of Ainput 
    input[31:0]      Read_data_2, //one of the sources of Binput 
    input[31:0]      Imme_extend, //one of the sources of Binput 
    input[5:0]       Function_opcode,//instructions[5:0] 
    input[5:0]       opcode,//instruction[31:26]
    input[1:0]       ALUOp, //{ (R_format || I_format) , (Branch || nBranch) } 
    input[4:0]       Shamt,// instruction[10:6], the amount of shift bits 
    input            ALUSrc,// 1 means the 2nd operand is an immedite (except beq，bne）
    input            I_format, // 1 means I-Type instruction except beq, bne, LW, SW 
    output           Zero,  // 1 means the ALU_reslut is zero, 0 otherwise
    input            Sftmd,// 1 means this is a shift instruction 
    output reg[31:0] ALU_Result, // the ALU calculation result
    output[31:0]     Addr_Result,// the calculated instruction address
    input[31:0]      PC_plus_4, // pc+4 
    input            Jr            // 1 means this is a jr instruction  
);

    wire [31:0] Ainput, Binput;
    reg[31:0] Sinput;
    reg [31:0] ALU_output_mux;
    wire [32:0] Branch_Addr;
    wire [2:0] ALU_ctl;
    wire [5:0] Exe_code;
    wire [2:0] Sftm;

    assign Sftm = Function_opcode[2:0];
    assign Exe_code = (I_format == 0) ? Function_opcode : {3'b000, opcode[2:0]};
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Imme_extend[31:0];
    
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
       
    always @* begin  
        if(Sftmd)
        case(Sftm[2:0])
            3'b000 :  Sinput = Binput << Shamt;
            3'b010 :  Sinput = Binput >> Shamt;
            3'b100 :  Sinput = Binput << Ainput;
            3'b110 :  Sinput = Binput >> Ainput;
            3'b011 :  Sinput = $signed(Binput)>>>Shamt;
            3'b111 :  Sinput = $signed(Binput)>>>Ainput;
            default :  Sinput = Binput;
        endcase
          else begin
             Sinput = Binput;
         end
    end
    
    always @* begin
        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) begin
             ALU_Result =($signed(Ainput) < $signed(Binput))? 32'd1:32'd0;
        end
        else if((ALU_ctl==3'b101) && (I_format==1))begin
            ALU_Result[31:0] = Imme_extend << 16;
        end
        else if(Sftmd==1)begin
            ALU_Result = Sinput;
        end
        else begin
            ALU_Result = ALU_output_mux;
        end
    end

    assign Branch_Addr = {3'b0, PC_plus_4[31:2]} + {1'b0, Imme_extend[31:0]};
    assign Addr_Result = Branch_Addr[31:0];
    assign Zero = (ALU_output_mux[31:0] == 32'h0000_0000)? 1'b1 : 1'b0;
       
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000 : ALU_output_mux = Ainput & Binput;
            3'b001 : ALU_output_mux = Ainput | Binput;
            3'b010 : ALU_output_mux = Ainput + Binput;
            3'b011 : ALU_output_mux = Ainput + Binput;
            3'b100 : ALU_output_mux = Ainput ^ Binput;
            3'b101 : ALU_output_mux = ~(Ainput | Binput);
            3'b110 : ALU_output_mux = Ainput + ~Binput + 1;
            3'b111 : ALU_output_mux = Ainput - Binput;
            default : ALU_output_mux = 32'h00000000;
        endcase
    end
endmodule