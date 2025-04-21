// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for otbn.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module otbn_assert_fpv
  import prim_alert_pkg::*;
  import otbn_pkg::*;
  import otbn_reg_pkg::*;
#(
  parameter bit Stub = 1'b0,
  parameter regfile_e RegFile = RegFileFF,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter urnd_prng_seed_t RndCnstUrndPrngSeed = RndCnstUrndPrngSeedDefault,
  parameter bit SecMuteUrnd = 1'b0,
  parameter bit SecSkipUrndReseedAtStart = 1'b0,
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnKey = RndCnstOtbnKeyDefault,
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnNonce = RndCnstOtbnNonceDefault
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_mubi_pkg::mubi4_t idle_o,
  input logic intr_done_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input lc_ctrl_pkg::lc_tx_t lc_rma_req_i,
  input lc_ctrl_pkg::lc_tx_t lc_rma_ack_o,
  input prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,
  input  clk_edn_i,
  input  rst_edn_ni,
  input edn_pkg::edn_req_t edn_rnd_o,
  input edn_pkg::edn_rsp_t edn_rnd_i,
  input edn_pkg::edn_req_t edn_urnd_o,
  input edn_pkg::edn_rsp_t edn_urnd_i,
  input  clk_otp_i,
  input  rst_otp_ni,
  input otp_ctrl_pkg::otbn_otp_key_req_t otbn_otp_key_o,
  input otp_ctrl_pkg::otbn_otp_key_rsp_t otbn_otp_key_i,
  input keymgr_pkg::otbn_key_req_t keymgr_key_i
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

endmodule : otbn_assert_fpv
