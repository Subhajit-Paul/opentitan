// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for hmac.
// Intended to be used with a formal tool.

module hmac_tb
  import prim_sha2_pkg::*;
  import hmac_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output logic intr_hmac_done_o,
  output logic intr_fifo_empty_o,
  output logic intr_hmac_err_o,
  output prim_mubi_pkg::mubi4_t idle_o
);


  hmac #(
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .intr_hmac_done_o,
    .intr_fifo_empty_o,
    .intr_hmac_err_o,
    .idle_o
  );


endmodule : hmac_tb
