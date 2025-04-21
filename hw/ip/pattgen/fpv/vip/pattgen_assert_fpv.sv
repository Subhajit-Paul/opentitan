// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for pattgen.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module pattgen_assert_fpv
  import pattgen_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input logic cio_pda0_tx_o,
  input logic cio_pcl0_tx_o,
  input logic cio_pda1_tx_o,
  input logic cio_pcl1_tx_o,
  input logic cio_pda0_tx_en_o,
  input logic cio_pcl0_tx_en_o,
  input logic cio_pda1_tx_en_o,
  input logic cio_pcl1_tx_en_o,
  input logic intr_done_ch0_o,
  input logic intr_done_ch1_o
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

endmodule : pattgen_assert_fpv
