`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/30 17:53:18
// Design Name: 
// Module Name: Recognize_Top
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


module Recognize_Top 
//YUZHI=20,night;YUZHI=74,day
#(parameter YUZHI = 74, HANG220 = 219, HANG360 = 359, HANG500 = 499, HANG550 = 549, HANG740 = 739, 
TURE = 1, SMALL1 = 120, SMALL2 = 40, MIDDLES = 120, MIDDLEY = 240, BIG = 320) 
    ( 
    input rst_n,   
    input vid_clk, 
     
    input vid_hsync, 
    input vid_vsync, 
    input vid_active_video, 
    input [7:0] vid_data,  
 
    input [10:0] hdata, 
    input [9:0] vdata, 
     
    output  [23:0] vid_data_out,  
    output  vid_hsync_out, 
    output  vid_vsync_out, 
    output  vid_active_video_out, 
    output  [7:0] data8_out, 
    output [2:0]shape ///
    ); 
     
    wire data_out1, data_in; 
     ///
    Threshold_Judge #( 
        .YUZHI(YUZHI), 
        .HANG220(HANG220), 
        .HANG360(HANG360), 
        .HANG500(HANG500), 
        .HANG550(HANG550) 
         )  
      Threshold_Judge_inst ( 
          .vid_clk(vid_clk),  
          .rst_n(rst_n),  
          .data_in(vid_data), 
          .vdata(vdata),  
          .data_out24(vid_data_out),  
          .data_out1(data_out1), 
          .shape(shape) , 
          .data8_out(data8_out) 
          ); 
  
      assign    data_in = ~data_out1;//day
     //assign    data_in = data_out1;//night
 
     
 
    Shape_Judge#( 
            .TURE(TURE), 
            .HANG220(HANG220), 
            .HANG360(HANG360), 
            .HANG500(HANG500), 
            .HANG740(HANG740), 
 
            .SMALL1(SMALL1), 
            .SMALL2(SMALL2), 
            .MIDDLES(MIDDLES), 
            .MIDDLEY(MIDDLEY), 
            .BIG(BIG) 
             )  
     Shape_Judge_inst   ( 
                        .rst_n(rst_n),  
                        .vid_clk(vid_clk), 
                         
                        .vid_hsync(vid_hsync), 
                        .vid_vsync(vid_vsync), 
                        .vid_active_video(vid_active_video), 
                        .data_in(data_in), 
                         
                        .hdata(hdata), 
                        .vdata(vdata), 
                         
                        .vid_hsync_out(vid_hsync_out), 
                        .vid_vsync_out(vid_vsync_out), 
                        .vid_active_video_out(vid_active_video_out), 
                                                 
                        .shape(shape)  
                        );     
 
endmodule 

