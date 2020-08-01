`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/23 16:57:40
// Design Name: 
// Module Name: Video_Generator
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
module Video_Generator(
    input clk,
    input RGB_VDE,
    input [10:0]Set_X,
    input [9:0]Set_Y,
    input [23:0]i_grey_data,
    input [23:0]i_origin_data,
    input [2:0]shape,
    input [2:0]color,
    
    output reg[23:0]RGB_Data=24'hffff00    //RBG
    );
    reg [23:0]color_temp = 24'hffffff;
    always@(*)
        begin
            if(color & 3'b001) 
                color_temp<=24'hff0000;
            else if(color & 3'b010)
                color_temp<=24'h0000ff;
            else if(color & 3'b100)
                color_temp<=24'h00ff00;
            else
                color_temp<=24'hffffff;
        end   
    always@(*)
        begin
            if((Set_Y == 219) || (Set_Y == 359) || (Set_Y == 499))//                    
                RGB_Data<=24'hff0000;
            else if(Set_Y<550)
                //RGB_Data<=i_grey_data; //show grey data
                RGB_Data<=i_origin_data; //show rgb data
            else if(Set_X<200)
                begin
                    if(shape & 3'b100)
                        begin
                            //draw a rectangle
                            if(Set_X == 20 && (Set_Y>=570 && Set_Y<=670))
                                RGB_Data<=24'hff0000;
                            else if(Set_X == 120 && (Set_Y>=570 && Set_Y<=670))
                                RGB_Data<=24'hff0000;
                            else if(Set_Y == 570 && (Set_X>=20 && Set_X<=120))
                                RGB_Data<=24'hff0000;
                            else if(Set_Y == 670 && (Set_X>=20 && Set_X<=120))
                                RGB_Data<=24'hff0000;
                            else if(Set_X>20 && Set_X<120 && Set_Y>570 && Set_Y<670)
                                RGB_Data<=color_temp;
                            else 
                                RGB_Data<=24'hffffff;
                        end   
                    else
                         RGB_Data<=24'hffffff;
                end
            else if(Set_X>=200 && Set_X<400)
                begin
                    if(shape & 3'b010)
                        begin
                        //draw a circle
                            if((((Set_X-300)*(Set_X-300)+(Set_Y-620)*(Set_Y-620)) <= 2500)&& (((Set_X-300)*(Set_X-300)+(Set_Y-620)*(Set_Y-620) >= 2400)))
                                RGB_Data<=24'hff0000; 
                            else if((Set_X-300)*(Set_X-300)+(Set_Y-620)*(Set_Y-620) < 2400)
                                RGB_Data<=color_temp;
                            else
                               RGB_Data<=24'hffffff; 
                        end
                    else
                        RGB_Data<=24'hffffff;
                end
            else if(Set_X>=400 && Set_X<600)
                begin
                    if(shape & 3'b001)
                        begin
                        //draw a triangle
                            if(Set_Y == 670 &&(Set_X>=450 && Set_X<=550))
                                RGB_Data<=24'hff0000;
                            else if((Set_X>=450 && Set_X<=500)&&(Set_Y==(-2*Set_X+1570)))
                                RGB_Data<=24'hff0000;
                            else if((Set_X>=500 && Set_X<=550)&&(Set_Y==(2*Set_X-430)))
                                RGB_Data<=24'hff0000;
                            else if((Set_Y<670) && (Set_Y>(-2*Set_X+1570)) && (Set_Y>(2*Set_X-430)))
                                RGB_Data<=color_temp;
                            else
                                RGB_Data<=24'hffffff;
                        end
                    else
                        RGB_Data<=24'hffffff;
                end
            else
                begin
                    RGB_Data<=24'hffffff;
                end           
        end

endmodule
