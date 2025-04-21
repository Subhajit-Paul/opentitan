// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module rom_ctrl_bind_fpv;


  bind rom_ctrl rom_ctrl_assert_fpv #(
    .BootRomInitFile(BootRomInitFile),
    .AlertAsyncOn(AlertAsyncOn),
    .RndCnstScrNonce(RndCnstScrNonce),
    .RndCnstScrKey(RndCnstScrKey),
    .MemSizeRom(MemSizeRom),
    .SecDisableScrambling(SecDisableScrambling)
  ) i_rom_ctrl_assert_fpv (
    .clk_i,
    .rst_ni,
    .rom_cfg_i,
    .rom_tl_i,
    .rom_tl_o,
    .regs_tl_i,
    .regs_tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .pwrmgr_data_o,
    .keymgr_data_o,
    .kmac_data_i,
    .kmac_data_o
  );


endmodule : rom_ctrl_bind_fpv
