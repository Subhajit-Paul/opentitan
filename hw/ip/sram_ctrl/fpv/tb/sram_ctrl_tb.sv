// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for sram_ctrl.
// Intended to be used with a formal tool.

module sram_ctrl_tb
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
  output tlul_pkg::tl_d2h_t ram_tl_o,
  input tlul_pkg::tl_h2d_t regs_tl_i,
  output tlul_pkg::tl_d2h_t regs_tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input lc_ctrl_pkg::lc_tx_t lc_hw_debug_en_i,
  input prim_mubi_pkg::mubi8_t otp_en_sram_ifetch_i,
  output otp_ctrl_pkg::sram_otp_key_req_t sram_otp_key_o,
  input otp_ctrl_pkg::sram_otp_key_rsp_t sram_otp_key_i,
  input prim_ram_1p_pkg::ram_1p_cfg_t cfg_i
);


  sram_ctrl #(
    .MemSizeRam(MemSizeRam),
    .AlertAsyncOn(AlertAsyncOn),
    .InstrExec(InstrExec),
    .NumPrinceRoundsHalf(NumPrinceRoundsHalf),
    .RndCnstSramKey(RndCnstSramKey),
    .RndCnstSramNonce(RndCnstSramNonce),
    .RndCnstLfsrSeed(RndCnstLfsrSeed),
    .RndCnstLfsrPerm(RndCnstLfsrPerm)
  ) dut (
    .clk_i,
    .rst_ni,
    .clk_otp_i,
    .rst_otp_ni,
    .ram_tl_i,
    .ram_tl_o,
    .regs_tl_i,
    .regs_tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .lc_escalate_en_i,
    .lc_hw_debug_en_i,
    .otp_en_sram_ifetch_i,
    .sram_otp_key_o,
    .sram_otp_key_i,
    .cfg_i
  );


endmodule : sram_ctrl_tb
