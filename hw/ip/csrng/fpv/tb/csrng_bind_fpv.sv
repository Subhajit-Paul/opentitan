// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module csrng_bind_fpv;


  bind csrng csrng_assert_fpv #(
    .SBoxImpl(SBoxImpl),
    .AlertAsyncOn(AlertAsyncOn),
    .NHwApps(NHwApps),
    .RndCnstCsKeymgrDivNonProduction(RndCnstCsKeymgrDivNonProduction),
    .RndCnstCsKeymgrDivProduction(RndCnstCsKeymgrDivProduction)
  ) i_csrng_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .otp_en_csrng_sw_app_read_i,
    .lc_hw_debug_en_i,
    .entropy_src_hw_if_o,
    .entropy_src_hw_if_i,
    .cs_aes_halt_i,
    .cs_aes_halt_o,
    .csrng_cmd_i,
    .csrng_cmd_o,
    .alert_rx_i,
    .alert_tx_o,
    .intr_cs_cmd_req_done_o,
    .intr_cs_entropy_req_o,
    .intr_cs_hw_inst_exc_o,
    .intr_cs_fatal_err_o
  );


endmodule : csrng_bind_fpv
