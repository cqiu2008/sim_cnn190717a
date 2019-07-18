//FILE_HEADER---------------------------------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//--------------------------------------------------------------------------------------------------
//Project Name : cnna
//FILE NAME    : loadweights.v
//AUTHOR       : qiu.chao 
//Department   : Technical Planning Department/System Products/ZTE
//Email        : qiu.chao@zte.com.cn
//--------------------------------------------------------------------------------------------------
//Module Hiberarchy :
//        |--U01_loadweights
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
module loadweights #(
parameter 
    MEM_STYLE               = "block"   ,
    C_POWER_OF_1ADOTS       = 4         ,
    C_POWER_OF_PECI         = 4         ,
    C_CNV_K_WIDTH           = 8         ,
    C_CNV_CH_WIDTH          = 8         ,
    C_M_AXI_ADDR_WIDTH      = 32        ,
    C_M_AXI_DATA_WIDTH      = 128       ,
    C_RAM_ADDR_WIDTH        = 512       ,
    C_RAM_DATA_WIDTH        = 128       
)(
// clk
input                               I_clk           ,
input                               I_rst           ,
// ap 
input                               I_ap_start      ,
output reg                          O_ap_done       ,
// reg
input       
input       [     C_CNV_K_WIDTH-1:0]I_next_kernel   ,
input       [    C_CNV_CH_WIDTH-1:0]I_next_ci       ,
input       [    C_CNV_CH_WIDTH-1:0]I_next_co       ,
input       [C_M_AXI_ADDR_WIDTH-1:0]I_base_addr     ,
// master read address channel
output reg  [C_M_AXI_LEN_WIDTH-1 :0]O_maxi_arlen    ,
input                               I_maxi_arready  ,   
output                              O_maxi_arvalid  ,
output reg  [C_M_AXI_ADDR_WIDTH-1:0]O_maxi_araddr   ,
// master read data channel
input       [                   1:0]I_maxi_rresp    ,
input       [                   1:0]I_maxi_rlast    ,   
output reg                          O_maxi_rready   ,
input                               I_maxi_rvalid   ,
input       [C_M_AXI_DATA_WIDTH-1:0]I_maxi_rdata    
);

defparam C_NCH_GROUP    = C_CNV_CH_WIDTH - C_POWER_OF_1ADOTS + 1    ;
defparam C_FILTER_WIDTH = C_CNV_K_WIDTH * C_CNV_K_WIDTH             ;

reg                          S_ap_start_1d      ;
wire [   C_POWER_OF_PECI  :0]S_peci_const       ;
wire [     C_NCH_GROUP-1  :0]S_next_co_group    ;   
wire [  C_CNV_CH_WIDTH-1  :0]S_next_co_align    ;   
wire [     C_NCH_GROUP-1  :0]S_next_ci_group    ;   
wire [  C_CNV_CH_WIDTH-1  :0]S_next_ci_align    ;   
wire [  C_FILTER_WIDTH-1  :0]S_next_filter      ;
reg  [     C_CNV_K_WIDTH-1:0]S_next_kernel_1d   ;
reg  [    C_CNV_CH_WIDTH-1:0]S_next_ci_1d       ;
reg  [    C_CNV_CH_WIDTH-1:0]S_next_co_1d       ;
reg  [     C_NCH_GROUP-1  :0]S_next_co_group_1d ;   
reg  [  C_CNV_CH_WIDTH-1  :0]S_next_co_align_1d ;   
reg  [     C_NCH_GROUP-1  :0]S_next_ci_group_1d ;   
reg  [  C_CNV_CH_WIDTH-1  :0]S_next_ci_align_1d ;   
reg  [  C_FILTER_WIDTH-1  :0]S_next_filter_1d   ;
wire [  C_FILTER_WIDTH-1  :0]S_filter_cnt       ;
wire [    C_CNV_CH_WIDTH-1:0]S_cig_cnt          ;
wire [    C_CNV_CH_WIDTH-1:0]S_ci_cnt           ;
wire [    C_CNV_CH_WIDTH-1:0]S_cog_cnt          ;
reg                          S_filter_valid     ;
reg                          S_cig_valid        ;
reg                          S_ci_valid         ;
reg                          S_cog_valid        ;

////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the varance value 
////////////////////////////////////////////////////////////////////////////////////////////////////

assign S_peci_const = {1'b1,(C_POWER_OF_PECI){1'b0}}; 
assign S_next_filter = I_next_kernel * I_next_kernel ;

ceil_power_of_2 #(
    .C_DIN_WIDTH    (C_CNV_CH_WIDTH     ),
    .C_POWER2_NUM   (C_POWER_OF_1ADOTS  ))
U0_next_co_group(
    .I_din (I_next_co       ),
    .O_dout(S_next_co_group )   
);
assign S_next_co_align = {S_next_co_group,(C_POWER_OF_1ADOTS){1'b0}};

ceil_power_of_2 #(
    .C_DIN_WIDTH    (C_CNV_CH_WIDTH     ),
    .C_POWER2_NUM   (C_POWER_OF_1ADOTS  ))
U0_next_ci_group(
    .I_din (I_next_ci       ),
    .O_dout(S_next_ci_group )   
);

assign S_next_ci_align = {S_next_ci_group,(C_POWER_OF_1ADOTS){1'b0}};

always @(posedge I_clk)begin
    S_next_kernel_1d   <=  I_next_kernel    ;
    S_next_ci_1d       <=  I_next_ci        ;  
    S_next_co_1d       <=  I_next_co        ; 
    S_next_co_group_1d <=  S_next_co_group  ;   
    S_next_co_align_1d <=  S_next_co_align  ;   
    S_next_ci_group_1d <=  S_next_ci_group  ;   
    S_next_ci_align_1d <=  S_next_ci_align  ;   
    S_next_filter_1d   <=  S_next_filter    ;
end

////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the varance value 
////////////////////////////////////////////////////////////////////////////////////////////////////
//// //// write here by cqiu 190718a

cm_cnt #(
    .C_WIDTH(C_FILTER_WIDTH))
U0_filter_cnt (
.I_clk       (I_clk             ),
.I_cnt_en    (I_ap_start        ),
.I_cnt_valid (S_filter_valid    ),
.I_cnt_upper (S_next_filter_1d  ),
.O_cnt       (S_filter_cnt      )
);

cm_cnt #(
    .C_WIDTH(C_CNV_CH_WIDTH))
U0_cig_cnt (
.I_clk       (I_clk             ),
.I_cnt_en    (I_ap_start        ),
.I_cnt_valid (S_cig_valid       ),
.I_cnt_upper (S_next_ci_group_1d),
.O_cnt       (S_cig_cnt         )
);

cm_cnt #(
    .C_WIDTH(C_CNV_CH_WIDTH))
U0_ci_cnt (
.I_clk       (I_clk             ),
.I_cnt_en    (I_ap_start        ),
.I_cnt_valid (S_ci_valid        ),
.I_cnt_upper (S_peci_const      ),
.O_cnt       (S_ci_cnt          )
);

cm_cnt #(
    .C_WIDTH(C_CNV_CH_WIDTH))
U0_cog_cnt (
.I_clk       (I_clk             ),
.I_cnt_en    (I_ap_start        ),
.I_cnt_valid (S_cog_valid       ),
.I_cnt_upper (S_next_co_group_1d),
.O_cnt       (S_cog_cnt         )
);

genvar i;

////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the varance value 
////////////////////////////////////////////////////////////////////////////////////////////////////

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
