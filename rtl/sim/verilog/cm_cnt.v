//FILE_HEADER---------------------------------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//--------------------------------------------------------------------------------------------------
//Project Name : cnna
//FILE NAME    : cm_cnt.v
//AUTHOR       : qiu.chao 
//Department   : Technical Planning Department/System Products/ZTE
//Email        : qiu.chao@zte.com.cn
//--------------------------------------------------------------------------------------------------
//Module Hiberarchy :
//        |--U01_cm_cnt
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
//Clock Strategy: none 
//Critical Timing: none 
//Asynchronous Interface: none 
//END_HEADER----------------------------------------------------------------------------------------
module cm_cnt #(
parameter 
    C_WIDTH         = 8     
)(
input                                   I_clk       ,
input                                   I_cnt_en    ,
input                                   I_cnt_valid ,
input       [               C_WIDTH-1:0]I_cnt_upper ,
output                                  O_over_flag ,
////wirte here
output reg  [               C_WIDTH-1:0]O_cnt         
);

wire S_cnt_b0       ;
reg  S_cnt_b0_1d    ; 
reg  S_cnt_b0_2d    ;
reg  S_cnt_en_1d    ; 
wire S_upper_case1  ;
wire S_upper_case2  ;
wire S_upper_case3  ;
wire S_cnt_turn_every_clk   ;
wire S_upper_equal2 ;
wire S_upper_more2  ;
wire  [C_WIDTH-1:0]S_cnt_upper_sub2;
wire  [C_WIDTH-1:0]S_cnt_upper_sub1;
reg   S_over_flag    ;

assign S_cnt_b0 = O_cnt[0];

always @(posedge I_clk)begin
    S_cnt_b0_1d <= S_cnt_b0     ;
    S_cnt_b0_2d <= S_cnt_b0_1d  ;
    S_cnt_en_1d <= I_cnt_en     ;
end

assign S_cnt_turn_every_clk = (S_cnt_b0 == S_cnt_b0_2d) && (S_cnt_b0 != S_cnt_b0_1d);///not active in I_cnt_upper==2
assign S_upper_equal2   = (I_cnt_upper == {{(C_WIDTH-2){1'b0}},2'b10});
assign S_upper_more2    = (I_cnt_upper >  {{(C_WIDTH-2){1'b0}},2'b10});
assign S_cnt_upper_sub2 = (I_cnt_upper -  {{(C_WIDTH-2){1'b0}},2'b10});
assign S_cnt_upper_sub1 = (I_cnt_upper -  {{(C_WIDTH-2){1'b0}},2'b01});
assign S_upper_case1  = (O_cnt == S_cnt_upper_sub1) && (!S_cnt_turn_every_clk); 
assign S_upper_case2  = (O_cnt == S_cnt_upper_sub2) && (S_upper_equal2 || S_upper_more2) && S_cnt_turn_every_clk; 

always @(posedge I_clk)begin
    S_over_flag <= S_upper_case1 || S_upper_case2; 
end

assign O_over_flag = S_over_flag || (S_upper_equal2 && (O_cnt[0] == 1'b1));

always @(posedge I_clk)begin
    if(I_cnt_en)begin
        if(I_cnt_valid)begin
            if(O_over_flag)begin
                O_cnt <= {(C_WIDTH){1'b0}};
            end
            else begin
                O_cnt <= O_cnt + {{(C_WIDTH-1){1'b0}},1'b1}; 
            end
        end
        else begin
            O_cnt <= O_cnt          ; 
        end
    end
    else begin
        O_cnt <= {(C_WIDTH){1'b0}};
    end
end

////////////////////////////////////////////////////////////////////////////////////////////////////
// Naming specification                                                                         
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                
//    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __
// __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  
//                                                                                                
//                                                                                                
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// instance                                                                                                
////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
