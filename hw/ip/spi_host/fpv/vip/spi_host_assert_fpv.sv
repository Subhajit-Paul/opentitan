// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for spi_host.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module spi_host_assert_fpv
  import spi_host_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input logic cio_sck_o,
  input logic cio_sck_en_o,
  input logic[NumCS-1:0] cio_csb_o,
  input logic[NumCS-1:0] cio_csb_en_o,
  input logic[3:0] cio_sd_o,
  input logic[3:0] cio_sd_en_o,
  input [3:0] cio_sd_i,
  input spi_device_pkg::passthrough_req_t passthrough_i,
  input spi_device_pkg::passthrough_rsp_t passthrough_o,
  input logic lsio_trigger_o,
  input logic intr_error_o,
  input logic intr_spi_event_o
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

endmodule : spi_host_assert_fpv
