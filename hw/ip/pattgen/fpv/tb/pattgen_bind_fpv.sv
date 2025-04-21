// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module pattgen_bind_fpv;


  bind pattgen pattgen_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_pattgen_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .cio_pda0_tx_o,
    .cio_pcl0_tx_o,
    .cio_pda1_tx_o,
    .cio_pcl1_tx_o,
    .cio_pda0_tx_en_o,
    .cio_pcl0_tx_en_o,
    .cio_pda1_tx_en_o,
    .cio_pcl1_tx_en_o,
    .intr_done_ch0_o,
    .intr_done_ch1_o
  );


endmodule : pattgen_bind_fpv
