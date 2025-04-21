// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for aon_timer.
// Intended to be used with a formal tool.

module aon_timer_tb
  import aon_timer_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input logic clk_i,
  input logic clk_aon_i,
  input logic rst_ni,
  input logic rst_aon_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  output logic intr_wkup_timer_expired_o,
  output logic intr_wdog_timer_bark_o,
  output logic nmi_wdog_timer_bark_o,
  output logic wkup_req_o,
  output logic aon_timer_rst_req_o,
  input logic sleep_mode_i
);


  aon_timer #(
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
    .lc_escalate_en_i,
    .intr_wkup_timer_expired_o,
    .intr_wdog_timer_bark_o,
    .nmi_wdog_timer_bark_o,
    .wkup_req_o,
    .aon_timer_rst_req_o,
    .sleep_mode_i
  );


endmodule : aon_timer_tb
