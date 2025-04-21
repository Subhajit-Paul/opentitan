// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for gpio.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module gpio_assert_fpv
  import gpio_pkg::*;
  import gpio_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter bit GpioAsHwStrapsEn = 1,
  parameter bit GpioAsyncOn = 1
) (
  input  clk_i,
  input  rst_ni,
  input  strap_en_i,
  input gpio_straps_t sampled_straps_o,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input logic[31:0] intr_gpio_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input [31:0] cio_gpio_i,
  input logic[31:0] cio_gpio_o,
  input logic[31:0] cio_gpio_en_o
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

endmodule : gpio_assert_fpv
