// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for aon_timer.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module aon_timer_assert_fpv
  import aon_timer_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input logic clk_i,
  input logic clk_aon_i,
  input logic rst_ni,
  input logic rst_aon_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,
  input logic intr_wkup_timer_expired_o,
  input logic intr_wdog_timer_bark_o,
  input logic nmi_wdog_timer_bark_o,
  input logic wkup_req_o,
  input logic aon_timer_rst_req_o,
  input logic sleep_mode_i
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

endmodule : aon_timer_assert_fpv
