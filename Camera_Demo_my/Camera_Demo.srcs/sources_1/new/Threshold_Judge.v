`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/30 17:08:29
// Design Name: 
// Module Name: Threshold_Judge
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


module Threshold_Judge
#(parameter YUZHI = 70, HANG220 = 219, HANG360 = 359, HANG500 = 499, HANG550 = 549) 
(vid_clk, rst_n, data_in, data_out1, data_out24, vdata, shape, data8_out); 

 
 input vid_clk, rst_n; 
 input [7:0] data_in; 
 input [9:0] vdata;   
 input [2:0] shape;  
 output reg data_out1; 
 output reg [23:0] data_out24; 
 output reg [7:0] data8_out;
  
 
// #(parameter YUZHI = 70, HANG220 = 219, HANG360 = 359, HANG500 = 499, HANG550 = 549) 
//(vid_clk, rst_n, data_in, data_out1, data_out24, vdata, shape, data8_out); 
    reg data_out1_1; 
    reg [23:0] data_out24_1;
        always @ (posedge vid_clk) 
    begin  
        if(!rst_n) 
            begin 
                data_out24_1 <= 0; 
                data_out1_1 <= 0; 
            end 
         else 
            begin 
                if(data_in >= YUZHI)//  
                    begin 
                        data_out1_1 <= 1; 
                        data_out24_1 <= 24'hff_ffff;                 
                    end 
                 else 
                    begin 
                        data_out1_1 <= 0; 
                        data_out24_1 <= 0;                     
                    end 
            end   
    end  
        
    always @ (posedge vid_clk) 
    begin  
        if(!rst_n) 
            begin 
                data_out24 <= 0; 
                data_out1 <= 0; 
                data8_out <= 0;    
            end 
         else 
            begin 
                if((vdata == HANG220) || (vdata == HANG360) || (vdata == HANG500))//                    
                    begin 
                        data_out1 <= data_out1_1; 
                        data_out24 <= 24'hff_0000; 
                        data8_out <= data8_out;                    
                    end 
                 else if((shape == 3'b010) && (vdata == HANG550))//00yuan 
                    begin 
                        data_out1 <= data_out1_1; 
                        data_out24 <= 24'hff_0000; 
                        data8_out <= 8'b1100_1100;                 
                    end 
                else if((shape == 3'b101) && (vdata == HANG550))//fang+s 
                          begin 
                              data_out1 <= data_out1_1; 
                              data_out24 <= 24'h00_ffff;  
                              data8_out <= 8'b1111_0000; 
                          end 
                 else if((shape == 3'b100) && (vdata == HANG550))//fang 
                       begin 
                           data_out1 <= data_out1_1; 
                           data_out24 <= 24'h00_ffff; 
                           data8_out <= 8'b1111_0000;                 
                       end 
                 else if((shape == 3'b001) && (vdata == HANG550))///////10san 
                       begin 
                           data_out1 <= data_out1_1; 
                           data_out24 <= 24'hff_ffff; 
                           data8_out <= 8'b1100_0011;                 
                       end 
                 else if((shape == 3'b110) && (vdata == HANG550))//11circle 
                       begin 
                           data_out1 <= data_out1_1; 
                           data_out24 <= 24'hff_0000; 
                           data8_out <= 8'b1100_1100;                  
                       end 
                 else if(vdata == HANG550)// 
                             begin 
                                 data_out1 <= data_out1_1; 
                                 data_out24 <= 24'h00_00ff; 
                                 data8_out <= data8_out;                 
                             end                         
                 else  
                    begin 
                        data_out1 <= data_out1_1; 
                        data_out24 <= data_out24_1; 
                        data8_out <= data8_out; 
                    end 
            end   
    end    
                        
endmodule
