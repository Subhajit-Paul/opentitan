// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for spi_host.
// Intended to be used with a formal tool.

module spi_host_tb
  import spi_host_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output logic cio_sck_o,
  output logic cio_sck_en_o,
  output logic[NumCS-1:0] cio_csb_o,
  output logic[NumCS-1:0] cio_csb_en_o,
  output logic[3:0] cio_sd_o,
  output logic[3:0] cio_sd_en_o,
  input [3:0] cio_sd_i,
  input spi_device_pkg::passthrough_req_t passthrough_i,
  output spi_device_pkg::passthrough_rsp_t passthrough_o,
  output logic lsio_trigger_o,
  output logic intr_error_o,
  output logic intr_spi_event_o
);


  spi_host #(
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
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


endmodule : spi_host_tb
