// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module spi_host_bind_fpv;


  bind spi_host spi_host_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_spi_host_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .cio_sck_o,
    .cio_sck_en_o,
    .cio_csb_o,
    .cio_csb_en_o,
    .cio_sd_o,
    .cio_sd_en_o,
    .cio_sd_i,
    .passthrough_i,
    .passthrough_o,
    .lsio_trigger_o,
    .intr_error_o,
    .intr_spi_event_o
  );


endmodule : spi_host_bind_fpv
