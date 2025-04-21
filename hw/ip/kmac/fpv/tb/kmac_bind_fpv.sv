// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module kmac_bind_fpv;


  bind kmac kmac_assert_fpv #(
    .EnMasking(EnMasking),
    .SwKeyMasked(SwKeyMasked),
    .SecCmdDelay(SecCmdDelay),
    .SecIdleAcceptSwMsg(SecIdleAcceptSwMsg),
    .RndCnstLfsrPerm(RndCnstLfsrPerm),
    .RndCnstLfsrSeed(RndCnstLfsrSeed),
    .RndCnstBufferLfsrSeed(RndCnstBufferLfsrSeed),
    .RndCnstMsgPerm(RndCnstMsgPerm),
    .AlertAsyncOn(AlertAsyncOn)
  ) i_kmac_assert_fpv (
    .clk_i,
    .rst_ni,
    .rst_shadowed_ni,
    .clk_edn_i,
    .rst_edn_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .keymgr_key_i,
    .app_i,
    .app_o,
    .entropy_o,
    .entropy_i,
    .lc_escalate_en_i,
    .intr_kmac_done_o,
    .intr_fifo_empty_o,
    .intr_kmac_err_o,
    .en_masking_o,
    .idle_o
  );


endmodule : kmac_bind_fpv
