`timescale 1ns / 1ps

module Tubs(led_clk,ledrst, ledwrite, ledcs, ledaddr,ledwdata, DIG,Y);
    input led_clk;
    input ledrst;
    input ledwrite;
    input ledcs;
    input[1:0] ledaddr;
    input[31:0] ledwdata;
    output[7:0]	DIG;
    output[7:0] Y;
    reg	[3:0]	din;
    reg [23:0] ledout;
    reg [31:0] ledtemp;
    
    
       always@(posedge led_clk or posedge ledrst) begin
         if(ledrst) begin
             ledtemp <= 32'h000000;
         end
         else if(ledcs && ledwrite) begin
             if(ledaddr == 2'b00) begin
                 ledtemp[31:0] <= ledwdata[31:0];
                 end
             else if(ledaddr == 2'b10 ) begin
                 ledtemp[31:0] <= ledwdata[31:0];
                 end
             else begin
                 ledtemp <= ledtemp;
                 end
         end
         else begin
             ledtemp <= ledtemp;
         end
      end
        
     segtube segtube32(
     .clk(led_clk),
     .rst(ledrst),
     .ledwdata(ledtemp),
     .DIG(DIG),
     .Y(Y)
     );

endmodule 