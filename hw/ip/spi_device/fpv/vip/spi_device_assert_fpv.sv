// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for spi_device.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module spi_device_assert_fpv
  import spi_device_reg_pkg::NumAlerts;
  import spi_device_reg_pkg::SPI_DEVICE_EGRESS_BUFFER_IDX;
  import spi_device_reg_pkg::SPI_DEVICE_INGRESS_BUFFER_IDX;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter spi_device_pkg::sram_type_e SramType = spi_device_pkg::DefaultSramType
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input  cio_sck_i,
  input  cio_csb_i,
  input logic[3:0] cio_sd_o,
  input logic[3:0] cio_sd_en_o,
  input [3:0] cio_sd_i,
  input  cio_tpm_csb_i,
  input spi_device_pkg::passthrough_req_t passthrough_o,
  input spi_device_pkg::passthrough_rsp_t passthrough_i,
  input logic intr_upload_cmdfifo_not_empty_o,
  input logic intr_upload_payload_not_empty_o,
  input logic intr_upload_payload_overflow_o,
  input logic intr_readbuf_watermark_o,
  input logic intr_readbuf_flip_o,
  input logic intr_tpm_header_not_empty_o,
  input logic intr_tpm_rdfifo_cmd_end_o,
  input logic intr_tpm_rdfifo_drop_o,
  input prim_ram_2p_pkg::ram_2p_cfg_t ram_cfg_i,
  input logic sck_monitor_o,
  input  mbist_en_i,
  input  scan_clk_i,
  input  scan_rst_ni,
  input prim_mubi_pkg::mubi4_t scanmode_i
);

  ///////////////////////////////
  // Declarations & Parameters //
  ///////////////////////////////

  /////////////////
  // Assumptions //
  /////////////////

  // `ASSUME(MyAssumption_M, ...)

  ////////////////////////
  // Forward Assertions //
  ////////////////////////

  // `ASSERT(MyFwdAssertion_A, ...)

  /////////////////////////
  // Backward Assertions //
  /////////////////////////

  // `ASSERT(MyBkwdAssertion_A, ...)

endmodule : spi_device_assert_fpv
