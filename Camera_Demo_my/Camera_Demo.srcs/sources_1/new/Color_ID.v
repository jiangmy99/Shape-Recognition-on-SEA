`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/31 14:23:43
// Design Name: 
// Module Name: Color_ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Color_ID(
  input i_clk,
  input [10:0]i_set_x,
  input [9:0] i_set_y,
  input [7:0]HSV_H,
  input [7:0]HSV_S,
  input [7:0]HSV_V,
  output reg[2:0]color_ID
    );
  always@(posedge i_clk)
      begin
          if(i_set_y>=350 && i_set_y<=370 && i_set_x>=490 && i_set_x<=510)
              begin
                  if(((HSV_H>=0 && HSV_H<=10)||(HSV_H>=156 && HSV_H<=180)) && (HSV_S>=43 && HSV_S<=255) && (HSV_V>=46 &&HSV_V<=255))
                    begin
                        color_ID[0]<=1;//red
                        color_ID[1]<=0;//green
                        color_ID[2]<=0;//blue
                    end
                  else if((HSV_H>=35&&HSV_H<=77) && (HSV_S>=43&&HSV_S<=255) && (HSV_V>=46&&HSV_V<=255))
                    begin
                        color_ID[0]<=0;//red
                        color_ID[1]<=1;//green
                        color_ID[2]<=0;//blue
                    end
                  else if((HSV_H>=100&&HSV_H<=124) && (HSV_S>=43&&HSV_S<=255) && (HSV_V>=46&&HSV_V<=255))
                    begin
                        color_ID[0]<=0;//red
                        color_ID[1]<=0;//green
                        color_ID[2]<=1;//blue
                    end
                  else
                    begin
                        color_ID[0]<=0;//red
                        color_ID[1]<=0;//green
                        color_ID[2]<=0;//blue
                    end
             end
         else
            color_ID<=color_ID;
      end

endmodule