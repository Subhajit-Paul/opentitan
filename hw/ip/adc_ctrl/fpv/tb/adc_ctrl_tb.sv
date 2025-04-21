// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for adc_ctrl.
// Intended to be used with a formal tool.

module adc_ctrl_tb
  import adc_ctrl_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  clk_aon_i,
  input  rst_ni,
  input  rst_aon_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output ast_pkg::adc_ast_req_t adc_o,
  input ast_pkg::adc_ast_rsp_t adc_i,
  output logic intr_match_pending_o,
  output logic wkup_req_o
);


  adc_ctrl #(
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
    .clk_i,
    .clk_aon_i,
    .rst_ni,
    .rst_aon_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .adc_o,
    .adc_i,
    .intr_match_pending_o,
    .wkup_req_o
  );


endmodule : adc_ctrl_tb
