`timescale 1ns / 1ps

module segtube(
rst,clk,DIG,Y,ledwdata
    );
    input rst;
    input clk;
    input [31:0]ledwdata;
    output [7:0] DIG;
    output [7:0] Y;
    
    wire clkout;
    wire [31:0] cnt;
    wire [2:0] scan_cnt;
    
//    parameter period = 100000000;

    wire [6:0] Y_r;
    wire [7:0] DIG_r;
    
//    always @ (posedge clk or negedge rst)
    
    frequency f (.rst(rst),.clk(clk),.scan_cnt(scan_cnt));
    
    control c (.scan_cnt(scan_cnt),.DIG_r(DIG_r),.Y_r(Y_r),.data(ledwdata));
    

    
    assign Y = {1'b1,(~Y_r[6:0])};
    assign DIG = ~DIG_r;
    

endmodule
