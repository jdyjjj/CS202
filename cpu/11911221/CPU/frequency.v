`timescale 1ns / 1ps

module frequency(
    clk,rst,scan_cnt
    );
    input clk,rst;
    output reg [2:0] scan_cnt;
    reg clkout;
    reg [31:0] cnt;
    parameter period = 20000;
    
    always @(posedge clk) 
        begin
            if (cnt == period)
            begin
                clkout <= ~clkout;
                cnt <= 0;
            end
            else
                cnt <= cnt + 1;
    end        
         
    always @ (posedge clkout)
        begin
            scan_cnt <= scan_cnt + 1;
            if (scan_cnt == 4'd7) 
                scan_cnt <= 0;
        end             
endmodule