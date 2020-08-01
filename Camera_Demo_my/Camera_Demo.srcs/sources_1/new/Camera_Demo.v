`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/25 09:56:56
// Design Name: 
// Module Name: Camera_Demo
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


module Camera_Demo(
    input i_clk,
    input i_rst,
    input i_clk_rx_data_n,
    input i_clk_rx_data_p,
    input [1:0]i_rx_data_n,
    input [1:0]i_rx_data_p,
    input i_data_n,
    input i_data_p,
    inout i_camera_iic_sda,
    output o_camera_iic_scl,
    output o_camera_gpio,
    output TMDS_Tx_Clk_N,
    output TMDS_Tx_Clk_P,
    output [2:0]TMDS_Tx_Data_N,
    output [2:0]TMDS_Tx_Data_P
    );
    //时钟信号
    wire clk_100MHz_system;
    wire clk_200MHz;
    wire clk_10MHz;
    //HDMI信号
    wire [23:0]rgb_data_src;
    wire rgb_hsync_src;
    wire rgb_vsync_src;
    wire rgb_vde_src;
    wire clk_pixel;
    //wire clk_serial;
    
    //系统时钟
    clk_wiz_0 clk_10(.clk_out1(clk_100MHz_system),.clk_out2(clk_200MHz),.clk_in1(i_clk));
    //摄像头IIC的SDA线的三态节点
    wire camera_iic_sda_i;
    wire camera_iic_sda_o;
    wire camera_iic_sda_t;
    
    //Tri-state gate
    IOBUF Camera_IIC_SDA_IOBUF
       (.I(camera_iic_sda_o),
        .IO(i_camera_iic_sda),
        .O(camera_iic_sda_i),
        .T(~camera_iic_sda_t));
    
    //摄像头IIC驱动信号
    wire iic_busy;
    wire iic_mode;
    wire [7:0]slave_addr;
    wire [7:0]reg_addr_h;
    wire [7:0]reg_addr_l;
    wire [7:0]data_w;
    wire [7:0]data_r;
    wire iic_write;
    wire iic_read;
    wire ov5647_ack;
    
    //摄像头驱动
    OV5647_Init MIPI_Camera_Driver(
        .i_clk(clk_100MHz_system),
        .i_rst(i_rst),
        .i_iic_busy(iic_busy),
        .o_iic_mode(iic_mode),          
        .o_slave_addr(slave_addr),    
        .o_reg_addr_h(reg_addr_h),   
        .o_reg_addr_l(reg_addr_l),   
        .o_data_w(data_w),      
        .o_iic_write(iic_write),
        .o_ack(ov5647_ack)                 
    );
    
    //摄像头IIC驱动
    Driver_IIC MIPI_Camera_IIC(
        .i_clk(clk_100MHz_system),
        .i_rst(i_rst),
        .i_iic_sda(camera_iic_sda_i),
        .i_iic_write(iic_write),                //IIC写信号,上升沿有效
        .i_iic_read(iic_read),                  //IIC读信号,上升沿有效
        .i_iic_mode(iic_mode),                  //IIC模式,1代表双地址位,0代表单地址位,低位地址有效
        .i_slave_addr(slave_addr),              //IIC从机地址
        .i_reg_addr_h(reg_addr_h),              //寄存器地址,高8位
        .i_reg_addr_l(reg_addr_l),              //寄存器地址,低8位
        .i_data_w(data_w),                      //需要传输的数据
        .o_data_r(data_r),                      //IIC读到的数据
        .o_iic_busy(iic_busy),                  //IIC忙信号,在工作时忙,低电平忙
        .o_iic_scl(o_camera_iic_scl),           //IIC时钟线
        .o_sda_dir(camera_iic_sda_t),           //IIC数据线方向,1代表输出
        .o_iic_sda(camera_iic_sda_o)            //IIC数据线
    );
        
    //图像MIPI信号转RGB    
    wire [10:0]o_set_x;
    wire [9:0]o_set_y;
    
    Driver_MIPI MIPI_Trans_Driver(
        .i_clk_200MHz(clk_200MHz),
        .i_clk_rx_data_n(i_clk_rx_data_n),
        .i_clk_rx_data_p(i_clk_rx_data_p),
        .i_rx_data_n(i_rx_data_n),
        .i_rx_data_p(i_rx_data_p),
        .i_data_n(i_data_n),
        .i_data_p(i_data_p),
        .o_camera_gpio(o_camera_gpio),
        .o_rgb_data(rgb_data_src),
        .o_rgb_hsync(rgb_hsync_src),
        .o_rgb_vsync(rgb_vsync_src),
        .o_rgb_vde(rgb_vde_src),
        .o_set_x(o_set_x),
        .o_set_y(o_set_y),
        .o_clk_pixel(clk_pixel)
    );
    
    //RGB2HSV
    wire [23:0]hsv_data_src;
    rgb2hsv_top RGB_To_HSV0(
        .pclk(clk_pixel),
        .RGB24({rgb_data_src[23:16],rgb_data_src[7:0],rgb_data_src[15:8]}),
        .HSV24(hsv_data_src)
    );
    //color id
    wire [2:0]color_ID;
    Color_ID Color_ID0(
        .i_clk(clk_pixel),
        .i_set_x(o_set_x),
        .i_set_y(o_set_y), 
        .HSV_H(hsv_data_src[23:16]),
        .HSV_S(hsv_data_src[15:8]),
        .HSV_V(hsv_data_src[7:0]),
        .color_ID(color_ID)
    );  
    
    //转灰度
    wire [7:0]Gray_Data;
    RGB_To_Gray RGB_To_Gray0(
        .RGB_Data_R(rgb_data_src[23:16]),
        .RGB_Data_G(rgb_data_src[7:0]),
        .RGB_Data_B(rgb_data_src[15:8]),
        .Accuracy_Num(),
        .Gray_Data(Gray_Data)
    );
    
    wire [23:0]grey_data_out; 
    wire [23:0]vid_data_out;
    wire vid_hsync_out;
    wire vid_vsync_out;
    wire vid_active_video_out;
    wire [2:0]shape;
    
    Recognize_Top Recognize_Top0(
        .rst_n(i_rst),   
        .vid_clk(clk_pixel),     
        .vid_hsync(rgb_hsync_src), 
        .vid_vsync(rgb_vsync_src), 
        .vid_active_video(rgb_vde_src), 
        .vid_data(Gray_Data),   
        .hdata(o_set_x), 
        .vdata(o_set_y), 
         
        .vid_data_out(grey_data_out),
        .vid_hsync_out(vid_hsync_out), 
        .vid_vsync_out(vid_vsync_out), 
        .vid_active_video_out(vid_active_video_out), 
        .data8_out(), 
        .shape(shape)
    );
    
    Video_Generator Video_Generator0(
        .clk(clk_pixel),
        .RGB_VDE(rgb_vde_src),
        .Set_X(o_set_x),
        .Set_Y(o_set_y),
        .i_grey_data(grey_data_out),
        .i_origin_data(rgb_data_src),
        .shape(shape),
        .color(color_ID),
        
        .RGB_Data(vid_data_out)
    );
    
    //HDMI驱动
    rgb2dvi_0 Mini_HDMI_Driver(
        .TMDS_Clk_p(TMDS_Tx_Clk_P),     // output wire TMDS_Clk_p
        .TMDS_Clk_n(TMDS_Tx_Clk_N),     // output wire TMDS_Clk_n
        .TMDS_Data_p(TMDS_Tx_Data_P),      // output wire [2 : 0] TMDS_Data_p
        .TMDS_Data_n(TMDS_Tx_Data_N),      // output wire [2 : 0] TMDS_Data_n
        .aRst_n(i_rst),                   // input wire aRst_n
        .vid_pData(vid_data_out),         // input wire [23 : 0] vid_pData
        .vid_pVDE(vid_active_video_out),           // input wire vid_pVDE
        .vid_pHSync(vid_hsync_out),       // input wire vid_pHSync
        .vid_pVSync(vid_vsync_out),       // input wire vid_pVSync
        .PixelClk(clk_pixel)
    ); 
endmodule
