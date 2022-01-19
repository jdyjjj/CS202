`timescale 1ns / 1ps

module Dmem_UART(read_data,address, write_data,Memwrite,clock,upg_rst_i,upg_clk_i,
                 upg_wen_i,upg_adr_i,upg_dat_i,upg_done_i); 
input clock; 
input[31:0] address; 
input Memwrite;
input[31:0] write_data; 
output[31:0] read_data;
input      upg_rst_i;
input      upg_clk_i;
input       upg_wen_i;
input[13:0] upg_adr_i;
input[31:0]  upg_dat_i;
input upg_done_i;

wire ram_clk=!clock;
wire kickOff= upg_rst_i|(~upg_rst_i&upg_done_i);
RAM ram ( .clka(kickOff?ram_clk:upg_clk_i),
.wea(kickOff?Memwrite:upg_wen_i),
.addra(kickOff?address[15:2]:upg_adr_i),
.dina(kickOff?write_data:upg_dat_i),
.douta(read_data)
);

endmodule