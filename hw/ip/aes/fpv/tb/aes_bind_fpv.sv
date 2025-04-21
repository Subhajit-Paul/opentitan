// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module aes_bind_fpv;


  bind aes aes_assert_fpv #(
    .AES192Enable(AES192Enable),
    .SecMasking(SecMasking),
    .SecSBoxImpl(SecSBoxImpl),
    .SecStartTriggerDelay(SecStartTriggerDelay),
    .SecAllowForcingMasks(SecAllowForcingMasks),
    .SecSkipPRNGReseeding(SecSkipPRNGReseeding),
    .AlertAsyncOn(AlertAsyncOn),
    .RndCnstClearingLfsrSeed(RndCnstClearingLfsrSeed),
    .RndCnstClearingLfsrPerm(RndCnstClearingLfsrPerm),
    .RndCnstClearingSharePerm(RndCnstClearingSharePerm),
    .RndCnstMaskingLfsrSeed(RndCnstMaskingLfsrSeed),
    .RndCnstMaskingLfsrPerm(RndCnstMaskingLfsrPerm)
  ) i_aes_assert_fpv (
    .clk_i,
    .rst_ni,
    .rst_shadowed_ni,
    .idle_o,
    .lc_escalate_en_i,
    .clk_edn_i,
    .rst_edn_ni,
    .edn_o,
    .edn_i,
    .keymgr_key_i,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o
  );


  bind aes tlul_assert #(
    .EndpointType("Device")
  ) i_tlul_assert_device (
    .clk_i,
    .rst_ni,
    .h2d  (tl_i),
    .d2h  (tl_o),
    .*
  );

  bind aes aes_csr_assert_fpv i_aes_csr_assert_fpv (
    .clk_i,
    .rst_ni,
    .h2d    (tl_i),
    .d2h    (tl_o)
  );

endmodule : aes_bind_fpv
