// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module otbn_bind_fpv;


  bind otbn otbn_assert_fpv #(
    .Stub(Stub),
    .RegFile(RegFile),
    .AlertAsyncOn(AlertAsyncOn),
    .RndCnstUrndPrngSeed(RndCnstUrndPrngSeed),
    .SecMuteUrnd(SecMuteUrnd),
    .SecSkipUrndReseedAtStart(SecSkipUrndReseedAtStart),
    .RndCnstOtbnKey(RndCnstOtbnKey),
    .RndCnstOtbnNonce(RndCnstOtbnNonce)
  ) i_otbn_assert_fpv (
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


endmodule : otbn_bind_fpv
