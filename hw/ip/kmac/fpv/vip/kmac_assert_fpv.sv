// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for kmac.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module kmac_assert_fpv
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
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input keymgr_pkg::hw_key_req_t keymgr_key_i,
  input app_req_t[NumAppIntf-1:0] app_i,
  input app_rsp_t[NumAppIntf-1:0] app_o,
  input edn_pkg::edn_req_t entropy_o,
  input edn_pkg::edn_rsp_t entropy_i,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input logic intr_kmac_done_o,
  input logic intr_fifo_empty_o,
  input logic intr_kmac_err_o,
  input logic en_masking_o,
  input prim_mubi_pkg::mubi4_t idle_o
);

  ///////////////////////////////
  // Declarations & Parameters //
  ///////////////////////////////

  /////////////////
  // Assumptions //
  /////////////////

  // `ASSUME(MyAssumption_M, ...)

  ////////////////////////
  // Forward Assertions //
  ////////////////////////

  // `ASSERT(MyFwdAssertion_A, ...)

  /////////////////////////
  // Backward Assertions //
  /////////////////////////

  // `ASSERT(MyBkwdAssertion_A, ...)

endmodule : kmac_assert_fpv
