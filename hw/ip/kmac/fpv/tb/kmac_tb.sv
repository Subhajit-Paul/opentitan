// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for kmac.
// Intended to be used with a formal tool.

module kmac_tb
  import kmac_pkg::*;
  import kmac_reg_pkg::*;
#(
  parameter bit EnMasking = 1,
  parameter bit SwKeyMasked = 0,
  parameter int SecCmdDelay = 0,
  parameter bit SecIdleAcceptSwMsg = 1'b0,
  parameter lfsr_perm_t RndCnstLfsrPerm = RndCnstLfsrPermDefault,
  parameter lfsr_seed_t RndCnstLfsrSeed = RndCnstLfsrSeedDefault,
  parameter buffer_lfsr_seed_t RndCnstBufferLfsrSeed = RndCnstBufferLfsrSeedDefault,
  parameter msg_perm_t RndCnstMsgPerm = RndCnstMsgPermDefault,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input  rst_shadowed_ni,
  input  clk_edn_i,
  input  rst_edn_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input keymgr_pkg::hw_key_req_t keymgr_key_i,
  input app_req_t[NumAppIntf-1:0] app_i,
  output app_rsp_t[NumAppIntf-1:0] app_o,
  output edn_pkg::edn_req_t entropy_o,
  input edn_pkg::edn_rsp_t entropy_i,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  output logic intr_kmac_done_o,
  output logic intr_fifo_empty_o,
  output logic intr_kmac_err_o,
  output logic en_masking_o,
  output prim_mubi_pkg::mubi4_t idle_o
);


  kmac #(
    .EnMasking(EnMasking),
    .SwKeyMasked(SwKeyMasked),
    .SecCmdDelay(SecCmdDelay),
    .SecIdleAcceptSwMsg(SecIdleAcceptSwMsg),
    .RndCnstLfsrPerm(RndCnstLfsrPerm),
    .RndCnstLfsrSeed(RndCnstLfsrSeed),
    .RndCnstBufferLfsrSeed(RndCnstBufferLfsrSeed),
    .RndCnstMsgPerm(RndCnstMsgPerm),
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
    .clk_i,
    .rst_ni,
    .rst_shadowed_ni,
    .clk_edn_i,
    .rst_edn_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .keymgr_key_i,
    .app_i,
    .app_o,
    .entropy_o,
    .entropy_i,
    .lc_escalate_en_i,
    .intr_kmac_done_o,
    .intr_fifo_empty_o,
    .intr_kmac_err_o,
    .en_masking_o,
    .idle_o
  );


endmodule : kmac_tb
