// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for edn.
// Intended to be used with a formal tool.

module edn_tb
  import edn_pkg::*;
  import edn_reg_pkg::*;
#(
  parameter int NumEndPoints = 8,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input logic clk_i,
  input logic rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input edn_req_t[NumEndPoints-1:0] edn_i,
  output edn_rsp_t[NumEndPoints-1:0] edn_o,
  output csrng_pkg::csrng_req_t csrng_cmd_o,
  input csrng_pkg::csrng_rsp_t csrng_cmd_i,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output logic intr_edn_cmd_req_done_o,
  output logic intr_edn_fatal_err_o
);


  edn #(
    .NumEndPoints(NumEndPoints),
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .edn_i,
    .edn_o,
    .csrng_cmd_o,
    .csrng_cmd_i,
    .alert_rx_i,
    .alert_tx_o,
    .intr_edn_cmd_req_done_o,
    .intr_edn_fatal_err_o
  );


endmodule : edn_tb
