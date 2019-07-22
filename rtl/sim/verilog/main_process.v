//FILE_HEADER---------------------------------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//--------------------------------------------------------------------------------------------------
//Project Name : cnna
//FILE NAME    : main_process.v.v
//AUTHOR       : qiu.chao 
//Department   : Technical Planning Department/System Products/ZTE
//Email        : qiu.chao@zte.com.cn
//--------------------------------------------------------------------------------------------------
//Module Hiberarchy :
//        |--U01_main_process.v
//        |--U02_axim_wddr
// cnna --|--U03_axis_reg
//        |--U04_main_process
//--------------------------------------------------------------------------------------------------
//Relaese History :
//--------------------------------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1           july-30-2019                    
//--------------------------------------------------------------------------------------------------
//Main Function:
//a)Get the data from ddr chip using axi master bus
//b)Write it to the ibuf ram
//--------------------------------------------------------------------------------------------------
//REUSE ISSUES: none
//Reset Strategy: synchronization 
//Clock Strategy: one common clock 
//Critical Timing: none 
//Asynchronous Interface: none 
//END_HEADER----------------------------------------------------------------------------------------
module main_process.v #(
parameter 
    MEM_STYLE               = "block"   ,
    C_POWER_OF_1ADOTS       = 4         ,
    C_POWER_OF_PECI         = 4         ,
    C_POWER_OF_PECO         = 5         ,
    C_POWER_OF_PECODIV      = 1         ,
    C_CNV_K_WIDTH           = 8         ,
    C_CNV_CH_WIDTH          = 8         ,
    C_M_AXI_LEN_WIDTH       = 32        ,
    C_M_AXI_ADDR_WIDTH      = 32        ,
    C_M_AXI_DATA_WIDTH      = 128       ,
    C_RAM_ADDR_WIDTH        = 9         ,
    C_RAM_DATA_WIDTH        = 128       


)(
// clk
input                               I_clk               ,
input                               I_rst               ,



// fi master channel
output reg  [C_M_AXI_LEN_WIDTH-1 :0]O_fimaxi_arlen      ,
input                               I_fimaxi_arready    ,   
output                              O_fimaxi_arvalid    ,
output reg  [C_M_AXI_ADDR_WIDTH-1:0]O_fimaxi_araddr     ,
output reg                          O_fimaxi_rready     ,
input                               I_fimaxi_rvalid     ,
input       [C_M_AXI_DATA_WIDTH-1:0]I_fimaxi_rdata      , 
// fo master channel
output reg  [C_M_AXI_LEN_WIDTH-1 :0]O_fomaxi_awlen      ,
input                               I_fomaxi_awready    ,   
output                              O_fomaxi_awvalid    ,
output reg  [C_M_AXI_ADDR_WIDTH-1:0]O_fomaxi_awaddr     ,
input                               I_fomaxi_wready     ,
output reg                          O_fomaxi_wvalid     ,
output      [C_M_AXI_DATA_WIDTH-1:0]O_fomaxi_wdata      ,   
input                               I_fomaxi_bvalid     ,
output reg                          O_fomaxi_bready     
);

localparam   C_NCH_GROUP      = C_CNV_CH_WIDTH - C_POWER_OF_1ADOTS + 1  ;

wire [       C_DLY_WIDTH-1:0]S_dly                          ;
reg  [       C_DLY_WIDTH-1:0]S_1dly                         ;

////////////////////////////////////////////////////////////////////////////////////////////////////
// Naming specification                                                                         
// (1) w+"xxx" name type , means write clock domain                                             
//        such as wrst,wclk,winc,wdata, wptr, waddr,wfull, and so on                            
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                
//    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __
// __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  
//                                                                                                
//                                                                                                
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
//        u0_wptr_full                                                                           
////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
