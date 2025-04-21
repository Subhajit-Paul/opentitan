// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for uart.
// Intended to be used with a formal tool.

module uart_tb
  import uart_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output logic lsio_trigger_o,
  input  cio_rx_i,
  output logic cio_tx_o,
  output logic cio_tx_en_o,
  output logic intr_tx_watermark_o,
  output logic intr_tx_empty_o,
  output logic intr_rx_watermark_o,
  output logic intr_tx_done_o,
  output logic intr_rx_overflow_o,
  output logic intr_rx_frame_err_o,
  output logic intr_rx_break_err_o,
  output logic intr_rx_timeout_o,
  output logic intr_rx_parity_err_o
);


  uart #(
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
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


endmodule : uart_tb
