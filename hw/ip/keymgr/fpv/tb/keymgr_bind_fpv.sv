// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module keymgr_bind_fpv;


  bind keymgr keymgr_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn),
    .UseOtpSeedsInsteadOfFlash(UseOtpSeedsInsteadOfFlash),
    .KmacEnMasking(KmacEnMasking),
    .RndCnstLfsrSeed(RndCnstLfsrSeed),
    .RndCnstLfsrPerm(RndCnstLfsrPerm),
    .RndCnstRandPerm(RndCnstRandPerm),
    .RndCnstRevisionSeed(RndCnstRevisionSeed),
    .RndCnstCreatorIdentitySeed(RndCnstCreatorIdentitySeed),
    .RndCnstOwnerIntIdentitySeed(RndCnstOwnerIntIdentitySeed),
    .RndCnstOwnerIdentitySeed(RndCnstOwnerIdentitySeed),
    .RndCnstSoftOutputSeed(RndCnstSoftOutputSeed),
    .RndCnstHardOutputSeed(RndCnstHardOutputSeed),
    .RndCnstNoneSeed(RndCnstNoneSeed),
    .RndCnstAesSeed(RndCnstAesSeed),
    .RndCnstOtbnSeed(RndCnstOtbnSeed),
    .RndCnstKmacSeed(RndCnstKmacSeed),
    .RndCnstCdi(RndCnstCdi)
  ) i_keymgr_assert_fpv (
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


endmodule : keymgr_bind_fpv
