// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module uart_bind_fpv;


  bind uart uart_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_uart_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .lsio_trigger_o,
    .cio_rx_i,
    .cio_tx_o,
    .cio_tx_en_o,
    .intr_tx_watermark_o,
    .intr_tx_empty_o,
    .intr_rx_watermark_o,
    .intr_tx_done_o,
    .intr_rx_overflow_o,
    .intr_rx_frame_err_o,
    .intr_rx_break_err_o,
    .intr_rx_timeout_o,
    .intr_rx_parity_err_o
  );


endmodule : uart_bind_fpv
