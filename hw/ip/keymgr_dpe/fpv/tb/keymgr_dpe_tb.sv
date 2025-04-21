// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for keymgr_dpe.
// Intended to be used with a formal tool.

module keymgr_dpe_tb
  import keymgr_pkg::*;
  import keymgr_dpe_pkg::*;
  import keymgr_dpe_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter bit UseOtpSeedsInsteadOfFlash = 1'b0,
  parameter bit KmacEnMasking = 1'b1,
  parameter lfsr_seed_t RndCnstLfsrSeed = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t RndCnstLfsrPerm = RndCnstLfsrPermDefault,
  parameter rand_perm_t RndCnstRandPerm = RndCnstRandPermDefault,
  parameter seed_t RndCnstRevisionSeed = RndCnstRevisionSeedDefault,
  parameter seed_t RndCnstSoftOutputSeed = RndCnstSoftOutputSeedDefault,
  parameter seed_t RndCnstHardOutputSeed = RndCnstHardOutputSeedDefault,
  parameter seed_t RndCnstNoneSeed = RndCnstNoneSeedDefault,
  parameter seed_t RndCnstAesSeed = RndCnstAesSeedDefault,
  parameter seed_t RndCnstOtbnSeed = RndCnstOtbnSeedDefault,
  parameter seed_t RndCnstKmacSeed = RndCnstKmacSeedDefault
) (
  input  clk_i,
  input  rst_ni,
  input  rst_shadowed_ni,
  input  clk_edn_i,
  input  rst_edn_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  output hw_key_req_t aes_key_o,
  output hw_key_req_t kmac_key_o,
  output otbn_key_req_t otbn_key_o,
  output kmac_pkg::app_req_t kmac_data_o,
  input kmac_pkg::app_rsp_t kmac_data_i,
  input  kmac_en_masking_i,
  input lc_ctrl_pkg::lc_tx_t lc_keymgr_en_i,
  input lc_ctrl_pkg::lc_keymgr_div_t lc_keymgr_div_i,
  input otp_ctrl_pkg::otp_keymgr_key_t otp_key_i,
  input otp_ctrl_pkg::otp_device_id_t otp_device_id_i,
  input flash_ctrl_pkg::keymgr_flash_t flash_i,
  output edn_pkg::edn_req_t edn_o,
  input edn_pkg::edn_rsp_t edn_i,
  input rom_ctrl_pkg::keymgr_data_t[NumRomDigestInputs-1:0] rom_digest_i,
  output logic intr_op_done_o,
  input prim_alert_pkg::alert_rx_t[keymgr_reg_pkg::NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[keymgr_reg_pkg::NumAlerts-1:0] alert_tx_o
);


  keymgr_dpe #(
    .AlertAsyncOn(AlertAsyncOn),
    .UseOtpSeedsInsteadOfFlash(UseOtpSeedsInsteadOfFlash),
    .KmacEnMasking(KmacEnMasking),
    .RndCnstLfsrSeed(RndCnstLfsrSeed),
    .RndCnstLfsrPerm(RndCnstLfsrPerm),
    .RndCnstRandPerm(RndCnstRandPerm),
    .RndCnstRevisionSeed(RndCnstRevisionSeed),
    .RndCnstSoftOutputSeed(RndCnstSoftOutputSeed),
    .RndCnstHardOutputSeed(RndCnstHardOutputSeed),
    .RndCnstNoneSeed(RndCnstNoneSeed),
    .RndCnstAesSeed(RndCnstAesSeed),
    .RndCnstOtbnSeed(RndCnstOtbnSeed),
    .RndCnstKmacSeed(RndCnstKmacSeed)
  ) dut (
    .clk_i,
    .rst_ni,
    .rst_shadowed_ni,
    .clk_edn_i,
    .rst_edn_ni,
    .tl_i,
    .tl_o,
    .aes_key_o,
    .kmac_key_o,
    .otbn_key_o,
    .kmac_data_o,
    .kmac_data_i,
    .kmac_en_masking_i,
    .lc_keymgr_en_i,
    .lc_keymgr_div_i,
    .otp_key_i,
    .otp_device_id_i,
    .flash_i,
    .edn_o,
    .edn_i,
    .rom_digest_i,
    .intr_op_done_o,
    .alert_rx_i,
    .alert_tx_o
  );


endmodule : keymgr_dpe_tb
