// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module spi_device_bind_fpv;


  bind spi_device spi_device_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn),
    .SramType(SramType)
  ) i_spi_device_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .cio_sck_i,
    .cio_csb_i,
    .cio_sd_o,
    .cio_sd_en_o,
    .cio_sd_i,
    .cio_tpm_csb_i,
    .passthrough_o,
    .passthrough_i,
    .intr_upload_cmdfifo_not_empty_o,
    .intr_upload_payload_not_empty_o,
    .intr_upload_payload_overflow_o,
    .intr_readbuf_watermark_o,
    .intr_readbuf_flip_o,
    .intr_tpm_header_not_empty_o,
    .intr_tpm_rdfifo_cmd_end_o,
    .intr_tpm_rdfifo_drop_o,
    .ram_cfg_i,
    .sck_monitor_o,
    .mbist_en_i,
    .scan_clk_i,
    .scan_rst_ni,
    .scanmode_i
  );


endmodule : spi_device_bind_fpv
