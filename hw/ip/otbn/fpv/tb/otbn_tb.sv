// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for otbn.
// Intended to be used with a formal tool.

module otbn_tb
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
  output tlul_pkg::tl_d2h_t tl_o,
  output prim_mubi_pkg::mubi4_t idle_o,
  output logic intr_done_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input lc_ctrl_pkg::lc_tx_t lc_rma_req_i,
  output lc_ctrl_pkg::lc_tx_t lc_rma_ack_o,
  input prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,
  input  clk_edn_i,
  input  rst_edn_ni,
  output edn_pkg::edn_req_t edn_rnd_o,
  input edn_pkg::edn_rsp_t edn_rnd_i,
  output edn_pkg::edn_req_t edn_urnd_o,
  input edn_pkg::edn_rsp_t edn_urnd_i,
  input  clk_otp_i,
  input  rst_otp_ni,
  output otp_ctrl_pkg::otbn_otp_key_req_t otbn_otp_key_o,
  input otp_ctrl_pkg::otbn_otp_key_rsp_t otbn_otp_key_i,
  input keymgr_pkg::otbn_key_req_t keymgr_key_i
);


  otbn #(
    .Stub(Stub),
    .RegFile(RegFile),
    .AlertAsyncOn(AlertAsyncOn),
    .RndCnstUrndPrngSeed(RndCnstUrndPrngSeed),
    .SecMuteUrnd(SecMuteUrnd),
    .SecSkipUrndReseedAtStart(SecSkipUrndReseedAtStart),
    .RndCnstOtbnKey(RndCnstOtbnKey),
    .RndCnstOtbnNonce(RndCnstOtbnNonce)
  ) dut (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .idle_o,
    .intr_done_o,
    .alert_rx_i,
    .alert_tx_o,
    .lc_escalate_en_i,
    .lc_rma_req_i,
    .lc_rma_ack_o,
    .ram_cfg_i,
    .clk_edn_i,
    .rst_edn_ni,
    .edn_rnd_o,
    .edn_rnd_i,
    .edn_urnd_o,
    .edn_urnd_i,
    .clk_otp_i,
    .rst_otp_ni,
    .otbn_otp_key_o,
    .otbn_otp_key_i,
    .keymgr_key_i
  );


endmodule : otbn_tb
