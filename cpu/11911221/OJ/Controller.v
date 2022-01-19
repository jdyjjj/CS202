module Controller(
  input[5:0]   Opcode,
  // instruction[31..26]    
  input[5:0]   Function_opcode,
  // instructions[5..0]    
  output       Jr,
   //1 indicates the instruction is "jr", otherwise it's not "jr"    
  output       RegDST,
  //1 indicate destination register is "rd",otherwise it's "rt"    

  output       ALUSrc,
  //1 indicate the 2nd data is immidiate (except "beq","bne")    
  output       MemtoReg,
  //1 indicate read data from memory and write it into register
  output       RegWrite,
  //1 indicate write register, otherwise it's not
  output       MemWrite,
  //1 indicate write data into memor
 
  output       Branch,
  //1 indicate the instruction is "beq" , otherwise it's not
  output       nBranch,
  //1 indicate the instruction is "bne", otherwise it's not
  output       Jmp,
  //1 indicate the instruction is "j", otherwise it's not
  output       Jal,
  //1 indicate the instruction is "jal", otherwise it's not
  output       I_format,
  //1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW"
  output       Sftmd,
  //1 indicate the instruction is shift instruction
  output[1:0]  ALUOp
  //if it's R-type or I_format=1,bit1 is 1, if it's "beq" or "bne"?,bit 0 is 1
);

wire r_type =( Opcode == 6'b000000)?1'b1:1'b0;
//wire i_type = !r_type && !j_type;
wire i_type;
assign i_type= (Opcode[5:3]==3'b001)?1'b1:1'b0;

assign Jr = (Opcode == 6'b000000 && Function_opcode == 6'b001000)? 1'b1:1'b0;

assign I_format = i_type;
assign Jmp = (Opcode == 6'b000010)?1'b1:1'b0;
assign Jal = (Opcode == 6'b000011)?1'b1:1'b0;
assign Branch = (Opcode == 6'b000100)?1'b1:1'b0;
assign nBranch =(Opcode == 6'b000101)?1'b1:1'b0;



assign RegDST = r_type;





wire lw = Opcode == 6'b100011;
wire sw = Opcode == 6'b101011;
assign RegDST = r_type;
assign MemtoReg = lw;
assign RegWrite = (r_type || lw || Jal || i_type) && (!Jr);
assign MemWrite = sw;
assign ALUSrc = i_type || MemtoReg|| MemWrite;

assign Sftmd = (r_type && Function_opcode[5:3] == 3'b000)? 1'b1:1'b0;

assign ALUOp = {(r_type || I_format), (Branch || nBranch)};
endmodule