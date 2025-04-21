// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for aes.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module aes_assert_fpv
  import aes_pkg::*;
  import aes_reg_pkg::*;
#(
  parameter bit AES192Enable = 1,
  parameter bit SecMasking = 1,
  parameter sbox_impl_e SecSBoxImpl = SBoxImplDom,
  parameter int unsigned SecStartTriggerDelay = 0,
  parameter bit SecAllowForcingMasks = 0,
  parameter bit SecSkipPRNGReseeding = 0,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter clearing_lfsr_seed_t RndCnstClearingLfsrSeed = RndCnstClearingLfsrSeedDefault,
  parameter clearing_lfsr_perm_t RndCnstClearingLfsrPerm = RndCnstClearingLfsrPermDefault,
  parameter clearing_lfsr_perm_t RndCnstClearingSharePerm = RndCnstClearingSharePermDefault,
  parameter masking_lfsr_seed_t RndCnstMaskingLfsrSeed = RndCnstMaskingLfsrSeedDefault,
  parameter masking_lfsr_perm_t RndCnstMaskingLfsrPerm = RndCnstMaskingLfsrPermDefault
) (
  input logic clk_i,
  input logic rst_ni,
  input logic rst_shadowed_ni,
  input prim_mubi_pkg::mubi4_t idle_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input logic clk_edn_i,
  input logic rst_edn_ni,
  input edn_pkg::edn_req_t edn_o,
  input edn_pkg::edn_rsp_t edn_i,
  input keymgr_pkg::hw_key_req_t keymgr_key_i,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o
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

endmodule : aes_assert_fpv
