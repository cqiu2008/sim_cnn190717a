debImport "-f" \
          "/home/cqiu/AIPrj/sim/sim_cnna190717a/runsim/run_qst_vrd_nuvm_vvd1602_hls_190717a/flist.f"
debLoadSimResult \
           /media/cqiu/e/work/prj/AIPrj/sim/sim_cnna190717a/runsim/run_qst_vrd_nuvm_vvd1602_hls_190717a/tb_dut_top.fsdb
wvCreateWindow
srcHBSelect "apatb_cnna_top.AESL_inst_cnna" -win $_nTrace1
srcSetScope -win $_nTrace1 "apatb_cnna_top.AESL_inst_cnna" -delim "."
srcHBSelect "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights" -win $_nTrace1
srcSetScope -win $_nTrace1 "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights" \
           -delim "."
verdiWindowResize -win Verdi_1 "260" "62" "1375" "876"
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_clk" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_rst" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_ap_start" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "O_ap_done" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 2454700.136612 7769659.562842
wvZoom -win $_nWave2 7319485.403789 7551833.356848
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_ap_start" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "O_ap_done" -win $_nTrace1
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
srcTraceLoad "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.O_ap_done" -win \
           $_nTrace1
nsMsgSwitchTab -tab trace
srcHBSelect "apatb_cnna_top.AESL_inst_cnna" -win $_nTrace1
srcSetScope -win $_nTrace1 "apatb_cnna_top.AESL_inst_cnna" -delim "."
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
srcSearchString "O_ap_done" -win $_nTrace1 -next -case
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ap_done" -win $_nTrace1
srcSearchString "ap_done" -win $_nTrace1 -next -case
srcSearchString "ap_done" -win $_nTrace1 -next -case
srcSearchString "ap_done" -win $_nTrace1 -next -case
debReload
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 7214683.879781 7769659.562842
wvZoom -win $_nWave2 7473975.797276 7542210.512407
wvSetCursor -win $_nWave2 7514245.465222 -snap {("G1" 4)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcHBSelect "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights" -win $_nTrace1
srcSetScope -win $_nTrace1 "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights" \
           -delim "."
srcHBSelect "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights" \
           -win $_nTrace1
srcSetScope -win $_nTrace1 \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights" \
           -delim "."
srcHBSelect \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\]" \
           -win $_nTrace1
srcSetScope -win $_nTrace1 \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\]" \
           -delim "."
srcHBSelect \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\].wbuf_co_ctrl\[0\]" \
           -win $_nTrace1
srcHBSelect \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\].wbuf_co_ctrl\[0\]" \
           -win $_nTrace1
srcSetScope -win $_nTrace1 \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\].wbuf_co_ctrl\[0\]" \
           -delim "."
srcHBSelect \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\].wbuf_co_ctrl\[0\].u_wbuf" \
           -win $_nTrace1
srcSetScope -win $_nTrace1 \
           "apatb_cnna_top.AESL_inst_cnna.u0_load_all_weights.u0_load_weights.wbuf_ci_ctrl\[0\].wbuf_co_ctrl\[0\].u_wbuf" \
           -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_clk" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_addr" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_data" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "I_wr" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "O_data" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 8)}
wvZoom -win $_nWave2 3052366.256831 4781328.961749
wvZoom -win $_nWave2 3628687.158469 3827092.714771
wvZoom -win $_nWave2 3674764.951599 3741442.228717
wvSetCursor -win $_nWave2 3693893.678641 -snap {("G1" 8)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 3329172.616373 3789719.492204
wvZoom -win $_nWave2 3544346.156719 3595937.473411
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 3502481.071863 3691931.152828
wvZoom -win $_nWave2 3522150.752399 3548031.911001
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSetCursor -win $_nWave2 2817568.852459 -snap {("G1" 3)}
debExit
