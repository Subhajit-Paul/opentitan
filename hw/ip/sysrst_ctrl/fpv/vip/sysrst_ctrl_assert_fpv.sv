// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for sysrst_ctrl.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module sysrst_ctrl_assert_fpv
  import sysrst_ctrl_pkg::*;
  import sysrst_ctrl_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  clk_aon_i,
  input  rst_ni,
  input  rst_aon_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input logic wkup_req_o,
  input logic rst_req_o,
  input logic intr_event_detected_o,
  input  cio_ac_present_i,
  input  cio_ec_rst_l_i,
  input  cio_key0_in_i,
  input  cio_key1_in_i,
  input  cio_key2_in_i,
  input  cio_pwrb_in_i,
  input  cio_lid_open_i,
  input  cio_flash_wp_l_i,
  input logic cio_bat_disable_o,
  input logic cio_flash_wp_l_o,
  input logic cio_ec_rst_l_o,
  input logic cio_key0_out_o,
  input logic cio_key1_out_o,
  input logic cio_key2_out_o,
  input logic cio_pwrb_out_o,
  input logic cio_z3_wakeup_o,
  input logic cio_bat_disable_en_o,
  input logic cio_flash_wp_l_en_o,
  input logic cio_ec_rst_l_en_o,
  input logic cio_key0_out_en_o,
  input logic cio_key1_out_en_o,
  input logic cio_key2_out_en_o,
  input logic cio_pwrb_out_en_o,
  input logic cio_z3_wakeup_en_o
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

endmodule : sysrst_ctrl_assert_fpv
