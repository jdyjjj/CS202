`timescale 1ns / 1ps
module CPU_UART(fpga_clk,fpga_rst,switch2N4,led2N4,Y,DIG,start_pg,rx,tx);//dis和sel是新加的！！！
output	[7:0] Y;//dis
output	[7:0]DIG;//sel
input fpga_clk;//可能要改成fpga_clk!!!!
input fpga_rst;//可能要改成fpga_rst!!!!
input[23:0] switch2N4;
output wire [23:0]led2N4;
input start_pg;   //Active High//Uart启动的按钮！！！
input rx;        // receive data by UART接收数据线
output tx;       // send data by UART   发送数据线

wire rst;
wire upg_clk,upg_clk_o;
wire upg_wen_o; // Uart write out enable
wire upg_done_o;// Uart rx data have done
//data to which memory unit of program _rom/dmemory32
wire[14:0] upg_adr_o;
wire[31:0]upg_dat_o;

wire spg_bufg;
BUFG U1(.I(start_pg),.O(spg_bufg)); //de-twitter  缓冲器！！去抖  自带的直接这么用就行了
//Generate UART Programmer reset signal
reg upg_rst;
always@(posedge fpga_clk)begin //应该clk换成fpga_clk!!!
   if(spg_bufg) upg_rst = 0;
   if (fpga_rst) upg_rst=1;
   end
   assign rst = fpga_rst|!upg_rst;

wire clock;
wire [31:0]Instruction; 
wire [31:0]PC_plus_4_out;
wire [31:0]Addr_result; 
wire [31:0]Read_data_1; 
wire Branch,nBranch,Jmp,Jal,Jr,Zero;
wire [31:0]opcplus4;
wire [31:0] next_PC;
wire [31:0]PC;
//
wire [31:0] Read_data_2; 
wire [31:0] read_data;
wire RegWrite; 
wire RegDst; 
wire [31:0]Sign_extend;

//
wire ALUSrc; 
wire MemorIOtoReg; 
wire MemRead; 
wire MemWrite;
wire IORead;
wire IOWrite;
wire I_format;
wire Sftmd;
wire [1:0]ALUOp;
//
wire [4:0]Shamt;
wire [31:0]ALU_Result; 
wire[31:0] read_data_fromMemory; 
wire[31:0] address; 
wire[31:0] write_data; 
wire [15:0]ioread_data;
wire switchcs;
wire [1:0]switchaddr; 
wire [15:0]switchrdata; 
wire [23:0]switch_i;

wire ledcs;
wire [1:0]ledaddr;                


clk1 cpuclk (
.clk_in1(fpga_clk),//原来是clk
.clk_out1(clock),
.clk_out2(upg_clk)
);


uart_bmpg_0 uartpg(
.upg_clk_i(upg_clk), 
.upg_rst_i(upg_rst),
.upg_clk_o(upg_clk_o),
.upg_wen_o(upg_wen_o),
.upg_adr_o(upg_adr_o),
.upg_dat_o(upg_dat_o),
.upg_done_o(upg_done_o),
.upg_rx_i(rx),
.upg_tx_o(tx)
);

 wire  upg_wen_i;
 assign upg_wen_i=upg_wen_o&upg_adr_o[14];
 
 wire  upg_wen_i1;
 assign upg_wen_i1=upg_wen_o&(!upg_adr_o[14]);



IFetch_UART ifetch(
.Instruction(Instruction),.pco(PC),.Addr_result(Addr_result),.Read_data_1(Read_data_1),.Branch(Branch),.nBranch(nBranch),.Jmp(Jmp),.Jal(Jal),
.Jr(Jr),.Zero(Zero),.clock(clock),.reset(rst),.link_addr(next_PC),.branch_base_addr(PC_plus_4_out),
.upg_rst_i(upg_rst),.upg_clk_i(upg_clk_o),
.upg_wen_i(upg_wen_i1),.upg_adr_i(upg_adr_o[13:0]),.upg_dat_i(upg_dat_o),.upg_done_i(upg_done_o)
);

Decoder idecode(
.read_data_1(Read_data_1),.read_data_2(Read_data_2),.Instruction(Instruction),.read_data(read_data),
.ALU_result(ALU_Result),.Jal(Jal),.RegWrite(RegWrite),.MemtoReg(MemorIOtoReg),.RegDst(RegDst),
.imme_extend(Sign_extend),.clock(clock),.reset(rst),.opcplus4(opcplus4)
);

ControllerIO control(
.Opcode(Instruction[31:26]),.Function_opcode(Instruction[5:0]),.Alu_resultHigh(ALU_Result[31:10]),.Jr(Jr),
.RegDST(RegDst),.ALUSrc(ALUSrc),
.MemorIOtoReg(MemorIOtoReg),.RegWrite(RegWrite),.MemRead(MemRead),.MemWrite(MemWrite),.IORead(IORead),
.IOWrite(IOWrite),.Branch(Branch),.nBranch(nBranch),
.Jmp(Jmp),.Jal(Jal),.I_format(I_format),.Sftmd(Sftmd),.ALUOp(ALUOp)
);

ALU execute(
.Read_data_1(Read_data_1),.Read_data_2(Read_data_2),.Imme_extend(Sign_extend),.Function_opcode(Instruction[5:0]),    //好几个都是instruction的部
.opcode(Instruction[31:26]),.ALUOp(ALUOp),.Shamt(Instruction[10:6]),    
.ALUSrc(ALUSrc),.I_format(I_format),
.Zero(Zero),.Jr(Jr),.Sftmd(Sftmd),.ALU_Result(ALU_Result),    
.Addr_Result(Addr_result),.PC_plus_4(PC_plus_4_out)
);


Dmem_UART memory(.read_data(read_data_fromMemory),.address(address),
.write_data(write_data),.Memwrite(MemWrite),.clock(clock),
.upg_rst_i(upg_rst),.upg_clk_i(upg_clk_o),
.upg_wen_i(upg_wen_i),.upg_adr_i(upg_adr_o[13:0]),.upg_dat_i(upg_dat_o),.upg_done_i(upg_done_o)
);

MemOrIO memio(
.caddress(ALU_Result),.memread(MemRead),.memwrite(MemWrite),.ioread(IORead),.iowrite(IOWrite),
.mread_data(read_data_fromMemory),.ioread_data(switchrdata),.wdata(Read_data_2),//之前是未知的 wdata
.rdata(read_data),.write_data(write_data),.address(address),.LEDCtrl(ledcs),.SwitchCtrl(switchcs)
);

Switch switch24(
.switclk(clock),.switrst(rst),.switchread(IORead),.switchcs(switchcs),
.switchaddr(address[1:0]),.switchrdata(switchrdata),.switch_i(switch2N4)
);

Tubs display24(
.led_clk(clock),
.ledrst(rst),
.ledwrite(IOWrite),
.ledcs(ledcs),
.ledaddr(address[1:0]),
.ledwdata(write_data[31:0]),
.Y(Y),
.DIG(DIG)
);

LED led(
.led_clk(clock),
.ledrst(rst),
.ledwrite(IOWrite),
.ledcs(ledcs),
.ledaddr(address[1:0]),
.ledwdata(write_data[16:0]),
.ledout(led2N4)
);
endmodule

