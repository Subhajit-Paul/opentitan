// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for sram_ctrl.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module sram_ctrl_assert_fpv
  import sram_ctrl_pkg::*;
  import sram_ctrl_reg_pkg::*;
#(
  parameter int MemSizeRam = 32'h1000,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter bit InstrExec = 1,
  parameter int NumPrinceRoundsHalf = 3,
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramKey = RndCnstSramKeyDefault,
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramNonce = RndCnstSramNonceDefault,
  parameter lfsr_seed_t RndCnstLfsrSeed = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t RndCnstLfsrPerm = RndCnstLfsrPermDefault
) (
  input logic clk_i,
  input logic rst_ni,
  input logic clk_otp_i,
  input logic rst_otp_ni,
  input tlul_pkg::tl_h2d_t ram_tl_i,
  input tlul_pkg::tl_d2h_t ram_tl_o,
  input tlul_pkg::tl_h2d_t regs_tl_i,
  input tlul_pkg::tl_d2h_t regs_tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input lc_ctrl_pkg::lc_tx_t lc_hw_debug_en_i,
  input prim_mubi_pkg::mubi8_t otp_en_sram_ifetch_i,
  input otp_ctrl_pkg::sram_otp_key_req_t sram_otp_key_o,
  input otp_ctrl_pkg::sram_otp_key_rsp_t sram_otp_key_i,
  input prim_ram_1p_pkg::ram_1p_cfg_t cfg_i
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

endmodule : sram_ctrl_assert_fpv
