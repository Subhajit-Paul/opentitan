// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module sram_ctrl_bind_fpv;


  bind sram_ctrl sram_ctrl_assert_fpv #(
    .MemSizeRam(MemSizeRam),
    .AlertAsyncOn(AlertAsyncOn),
    .InstrExec(InstrExec),
    .NumPrinceRoundsHalf(NumPrinceRoundsHalf),
    .RndCnstSramKey(RndCnstSramKey),
    .RndCnstSramNonce(RndCnstSramNonce),
    .RndCnstLfsrSeed(RndCnstLfsrSeed),
    .RndCnstLfsrPerm(RndCnstLfsrPerm)
  ) i_sram_ctrl_assert_fpv (
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


endmodule : sram_ctrl_bind_fpv
