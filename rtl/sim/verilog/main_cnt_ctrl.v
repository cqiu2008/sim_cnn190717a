//FILE_HEADER---------------------------------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//--------------------------------------------------------------------------------------------------
//Project Name : cnna
//FILE NAME    : main_cnt_ctrl.v
//AUTHOR       : qiu.chao 
//Department   : Technical Planning Department/System Products/ZTE
//Email        : qiu.chao@zte.com.cn
//--------------------------------------------------------------------------------------------------
//Module Hiberarchy :
//        |--U01_main_cnt_ctrl.v
//        |--U02_axim_wddr
// cnna --|--U03_axis_reg
//        |--U04_main_cnt_ctrl
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
module main_cnt_ctrl #(
parameter 
    MEM_STYLE               = "block"   ,
    C_POWER_OF_1ADOTS       = 4         ,
    C_POWER_OF_PECI         = 4         ,
    C_POWER_OF_PECO         = 5         ,
    C_POWER_OF_PEPIX        = 3         ,
    C_POWER_OF_PECODIV      = 1         ,
    C_CNV_K_WIDTH           = 8         ,
    C_CNV_CH_WIDTH          = 8         ,
    C_DIM_WIDTH             = 16        
)(
// clk
input                               I_clk               ,
input                               I_rst               ,
input       [       C_DIM_WIDTH-1:0]I_hcnt_total        ,
output reg  [       C_DIM_WIDTH-1:0]O_hcnt              ,
input                               I_ap_start          ,
output reg                          O_ap_done           ,
output reg                          O_ldap_start        ,
input                               I_ldap_done         ,
output reg                          O_swap_start        ,
input                               I_swap_done         ,
output reg                          O_peap_start        ,
input                               I_peap_done         ,
output reg                          O_pqap_start        ,
input                               I_pqap_done         ,
output reg                          O_ppap_start        ,
input                               I_ppap_done         ,
output reg                          O_mpap_start        ,
input                               I_mpap_done             
);

localparam   C_WO_GROUP       = C_DIM_WIDTH - C_POWER_OF_PEPIX + 1  ;
localparam   C_CI_GROUP       = C_CNV_CH_WIDTH - C_POWER_OF_1ADOTS+1; 

wire         [       C_DIM_WIDTH-1:0]S_hcnt              ;
reg                                  S_ap_start_1d       ;
reg                                  S_ldap_done_lck     ;
reg                                  S_swap_done_lck     ;
reg                                  S_peap_done_lck     ;
reg                                  S_pqap_done_lck     ;
reg                                  S_ppap_done_lck     ;
reg                                  S_mpap_done_lck     ;   
reg                                  S_all_done_lck      ;
reg                                  S_all_done_lck_1d   ;
reg                                  S_hcnt_valid        ;

////////////////////////////////////////////////////////////////////////////////////////////////////
// initial variable
////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge I_clk)begin
    S_all_done_lck  <=  S_ldap_done_lck & 
                        S_swap_done_lck & 
                        S_peap_done_lck & 
                        S_pqap_done_lck & 
                        S_ppap_done_lck & 
                        S_mpap_done_lck ;
    S_all_done_lck_1d <= S_all_done_lck ;
end

always @(posedge I_clk)begin
    if(I_ap_start)begin
        if(I_ap_done)begin
            O_ap_done_lck <= 1'b1;
        end
        else begin
            O_ap_done_lck <= 1'b0;
        end
    end
    else begin
        O_ap_done_lck <= 1'b1;
    end
end

cm_cnt #(
    .C_WIDTH(C_DIM_WIDTH))
u0_hcnt(
    .I_clk               (I_clk         ),
    .I_cnt_en            (I_ap_start    ),
    .I_lowest_cnt_valid  (1'b1          ),
    .I_cnt_valid         (S_hcnt_valid  ),
    .I_cnt_upper         (I_hcnt_total  ),
    .O_over_flag         (              ),
    .O_cnt               (S_hcnt        ) 
);

// always @(posedge I_clk)begin
//     if(I_ap_start)begin
//         if(S_hcnt_valid)begin
//             S_hcnt <= {{(C_DIM_WIDTH-1){1'b0}},1'b1};
//         end
//         else begin
//             S_hcnt <= S_hcnt                ; 
//         end
//     end
//     else begin
//         S_hcnt <= {C_DIM_WIDTH{1'b0}};
//     end
// end




// ceil_power_of_2 #(
//     .C_DIN_WIDTH    (C_CNV_CH_WIDTH     ),
//     .C_POWER2_NUM   (C_POWER_OF_1ADOTS  ))
// U0_next_co_group_peco(
//     .I_din (I_ipara_ci          ),
//     .O_dout(S_ipara_ci_group    )   
// );
// 
// always @(posedge I_clk)begin
//     S_ipara_ci_group_1d <= S_ipara_ci_group                     ;
// end

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
