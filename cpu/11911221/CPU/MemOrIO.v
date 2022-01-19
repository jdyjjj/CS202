`timescale 1ns / 1ps

module MemOrIO(caddress,address,memread,memwrite,ioread,iowrite,mread_data,ioread_data,wdata,rdata,write_data,LEDCtrl,SwitchCtrl);
    input[31:0] caddress;       // from alu_result in executs32
    input memread;				// read memory, from control32
    input memwrite;				// write memory, from control32
    input ioread;				// read IO, from control32
    input iowrite;				// write IO, from control32
    input[31:0] mread_data;		// data from memory
    input[15:0] ioread_data;	// data from io,16 bits  
    input[31:0] wdata;			// the data from idecode32,that want to write memory or io
    output[31:0] rdata;			// data from memory or IO that want to read into register
    output[31:0] write_data;    // data to memory or I/O
    output[31:0] address;       // address to mAddress and I/O
    output LEDCtrl;				// LED CS
    output SwitchCtrl;          // Switch CS

   reg[31:0] write_data; 
   wire iorw;
assign address = caddress; 
assign rdata = (ioread == 1)?{16'h0000,ioread_data}:mread_data;
assign iorw = (iowrite||ioread);

assign LEDCtrl= iowrite == 1'b1;
assign SwitchCtrl= ioread == 1'b1;

always @* begin 
    if((memwrite== 1'b1)||(iowrite==1'b1)) 
    begin 
    write_data = wdata;
    end 
    else begin 
    write_data = 32'haaaaaaaa; 
    end 
end 
endmodule 