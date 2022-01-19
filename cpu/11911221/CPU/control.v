`timescale 1ns / 1ps

module control(
scan_cnt,DIG_r,Y_r,data
    );
    //input[31:0] data;
    input[31:0] data;
    input [2:0] scan_cnt;
    output reg [7:0] DIG_r;
    output reg [6:0] Y_r;
    reg [3:0] temp;
              always @(scan_cnt)
                begin 
                    case (scan_cnt)
                        3'b000: begin DIG_r = 8'b00000001;temp=data[3:0];end
                        3'b001: begin DIG_r = 8'b00000010;temp=data[7:4];end
                        3'b010: begin DIG_r = 8'b00000100;temp=data[11:8];end
                        3'b011: begin DIG_r = 8'b00001000;temp=data[15:12];end
                        3'b100: begin DIG_r = 8'b00010000;temp=data[19:16];end    
                        3'b101: begin DIG_r = 8'b00100000;temp=data[23:20];end
                        3'b110: begin DIG_r = 8'b01000000;temp=data[27:24];end
                        3'b111: begin DIG_r = 8'b10000000;temp=data[31:28];end
                        default:begin  DIG_r = 8'b00000000;temp=data[3:0];end
                    endcase
                end
    always @ (scan_cnt)
    begin
        case (temp)
            0: Y_r = 7'b0111111;
            1: Y_r = 7'b0000110;
            2: Y_r = 7'b1011011;
            3: Y_r = 7'b1001111;
            4: Y_r = 7'b1100110;
            5: Y_r = 7'b1101101;
            6: Y_r = 7'b1111101;
            7: Y_r = 7'b0000111;
            8: Y_r = 7'b1111111;
            9: Y_r = 7'b1101111;
            10: Y_r = 7'b1110111;//a
            11: Y_r = 7'b1111100;//b
            12: Y_r = 7'b0111001;//c
            13: Y_r = 7'b1011110;//d
            14: Y_r = 7'b1111001;//e
            15: Y_r = 7'b1110001;//f
            default: Y_r = 7'b0000000;
        endcase
    end
endmodule