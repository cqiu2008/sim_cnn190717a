//FILE_HEADER---------------------------------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//--------------------------------------------------------------------------------------------------
//Project Name : cnna
//FILE NAME    : multi_slide_windows_flatten.v
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
module multi_slide_windows_flatten #(
parameter 
    MEM_STYLE               = "block"   ,
    C_POWER_OF_1ADOTS       = 4         ,
    C_POWER_OF_PECI         = 4         ,
    C_POWER_OF_PECO         = 5         ,
    C_POWER_OF_PEPIX        = 3         ,
    C_POWER_OF_PECODIV      = 1         ,
    C_CNV_K_WIDTH           = 8         ,
    C_CNV_CH_WIDTH          = 8         ,
    C_DIM_WIDTH             = 16        ,
    C_M_AXI_LEN_WIDTH       = 32        ,
    C_M_AXI_ADDR_WIDTH      = 32        ,
    C_M_AXI_DATA_WIDTH      = 128       ,
    C_RAM_ADDR_WIDTH        = 9         ,
    C_RAM_DATA_WIDTH        = 128       
)(
// clk
input                               I_clk               ,
input                               I_rst               ,
input                               I_allap_start       ,
input                               I_ap_start          ,
output                              O_ap_done           ,
//ibuf
input       [C_RAM_ADDR_WIDTH-1  :0]I_ibuf0_addr        , 
input       [C_RAM_ADDR_WIDTH-1  :0]I_ibuf1_addr        , 
output reg  [C_RAM_DATA_WIDTH-1  :0]O_ibuf0_rdata       , 
output reg  [C_RAM_DATA_WIDTH-1  :0]O_ibuf1_rdata       , 
// reg
input       [       C_DIM_WIDTH-1:0]I_ipara_height      ,
input       [       C_DIM_WIDTH-1:0]I_hindex            ,
input                               I_hcnt_odd           //1,3,5,...active
input       [     C_CNV_K_WIDTH-1:0]I_kernel_h          ,
input       [     C_CNV_K_WIDTH-1:0]I_stride_h          ,
input       [     C_CNV_K_WIDTH-1:0]I_pad_h             ,
input       [       C_DIM_WIDTH-1:0]I_ipara_width       ,
//input       [     C_CNV_K_WIDTH-1:0]I_kernel_h          ,
//input       [     C_CNV_K_WIDTH-1:0]I_stride_h          ,
//input       [     C_CNV_K_WIDTH-1:0]I_pad_h             ,
//input       [       C_DIM_WIDTH-1:0]I_opara_width       ,
//input       [       C_DIM_WIDTH-1:0]I_opara_height      ,
//input       [    C_CNV_CH_WIDTH-1:0]I_opara_co          ,
//input       [    C_CNV_CH_WIDTH-1:0]I_ipara_ci          ,
//input       [       C_DIM_WIDTH-1:0]I_ipara_width       ,
//input       [       C_DIM_WIDTH-1:0]I_ipara_height      ,
);

wire [       C_DIM_WIDTH-1:0]S_hcnt             ;
wire                         S_hindex_suite     ;
wire [       C_DIM_WIDTH-1:0]S_sbuf0_index      ; 
wire [       C_DIM_WIDTH-1:0]S_sbuf1_index      ; 
reg                          S_sbuf0_index_neq  ; 
reg                          S_sbuf1_index_neq  ; 
reg  [        C_AP_START-1:0]S_ap_start_shift   ; 
reg                          S_swap_start       ;
wire                         S_swap_done        ;
reg                          S_sbuf0_en         ;
reg                          S_sbuf1_en         ;
reg                          S_no_suite_done    ;


localparam   C_AP_START       = 16                              ; 
localparam   C_PEPIX          ={1'b1,{C_POWER_OF_PEPIX{1'b0}}}  ;

////////////////////////////////////////////////////////////////////////////////////////////////////
// initial variable
////////////////////////////////////////////////////////////////////////////////////////////////////

index_lck #(
    .C_DIM_WIDTH (C_DIM_WIDTH ))
u_sbuf0_index(
    .I_clk        (I_clk          ),
    .I_ap_start   (I_allap_start  ),
    .I_index_en   (S_sbuf0_en     ),
    .I_index      (I_hindex       ),
    .O_index_lck  (S_sbuf0_index  )     
);

index_lck #(
    .C_DIM_WIDTH (C_DIM_WIDTH ))
u_sbuf1_index(
    .I_clk        (I_clk          ),
    .I_ap_start   (I_allap_start  ),
    .I_index_en   (S_sbuf1_en     ),
    .I_index      (I_hindex       ),
    .O_index_lck  (S_sbuf1_index  )     
);

suite_range #(
    .C_DIM_WIDTH (C_DIM_WIDTH))
u_suite_range(
    .I_clk          (I_clk           ),
    .I_index        (I_hindex        ),
    .I_index_upper  (I_ipara_height  ),
    .O_index_suite  (S_hindex_suite  )
);

always @(posedge I_clk)begin
    S_ap_start_shift    <= {S_ap_start_shift[C_AP_START-2:0],I_ap_start}        ;
    S_sbuf0_index_neq   <= S_sbuf0_index != I_hindex                            ; 
    S_sbuf1_index_neq   <= S_sbuf1_index != I_hindex                            ; 
end

always @(posedge I_clk)begin
    if(I_ap_start)begin
        if(S_ap_start_shift[7:6] == 2'b01)begin
            S_sbuf0_en  <= S_hindex_suite && S_sbuf0_index_neq && ( I_hcnt_odd) ;
            S_sbuf1_en  <= S_hindex_suite && S_sbuf1_index_neq && (~I_hcnt_odd) ;
        end
        else begin
            S_sbuf0_en  <= S_sbuf0_en   ; 
            S_sbuf1_en  <= S_sbuf1_en   ; 
        end
    end
    else begin
        S_sbuf0_en <= 1'b0;
        S_sbuf1_en <= 1'b0;
    end
end
always @(posedge I_clk)begin
    S_swap_start <= S_sbuf0_en | S_sbuf1_en;
end

always @(posedge I_clk)begin
    S_no_suite_done  = (S_ap_start_shift[9:8]==2'b01) && (~S_swap_start); 
    O_ap_done        = S_no_suite_done || S_swap_done                   ; 
end

////////////////////////////////////////////////////////////////////////////////////////////////////
// main cnt ctrl and ap controller 
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// load_image  
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
