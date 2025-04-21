// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for sysrst_ctrl.
// Intended to be used with a formal tool.

module sysrst_ctrl_tb
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
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output logic wkup_req_o,
  output logic rst_req_o,
  output logic intr_event_detected_o,
  input  cio_ac_present_i,
  input  cio_ec_rst_l_i,
  input  cio_key0_in_i,
  input  cio_key1_in_i,
  input  cio_key2_in_i,
  input  cio_pwrb_in_i,
  input  cio_lid_open_i,
  input  cio_flash_wp_l_i,
  output logic cio_bat_disable_o,
  output logic cio_flash_wp_l_o,
  output logic cio_ec_rst_l_o,
  output logic cio_key0_out_o,
  output logic cio_key1_out_o,
  output logic cio_key2_out_o,
  output logic cio_pwrb_out_o,
  output logic cio_z3_wakeup_o,
  output logic cio_bat_disable_en_o,
  output logic cio_flash_wp_l_en_o,
  output logic cio_ec_rst_l_en_o,
  output logic cio_key0_out_en_o,
  output logic cio_key1_out_en_o,
  output logic cio_key2_out_en_o,
  output logic cio_pwrb_out_en_o,
  output logic cio_z3_wakeup_en_o
);


  sysrst_ctrl #(
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
    .wkup_req_o,
    .rst_req_o,
    .intr_event_detected_o,
    .cio_ac_present_i,
    .cio_ec_rst_l_i,
    .cio_key0_in_i,
    .cio_key1_in_i,
    .cio_key2_in_i,
    .cio_pwrb_in_i,
    .cio_lid_open_i,
    .cio_flash_wp_l_i,
    .cio_bat_disable_o,
    .cio_flash_wp_l_o,
    .cio_ec_rst_l_o,
    .cio_key0_out_o,
    .cio_key1_out_o,
    .cio_key2_out_o,
    .cio_pwrb_out_o,
    .cio_z3_wakeup_o,
    .cio_bat_disable_en_o,
    .cio_flash_wp_l_en_o,
    .cio_ec_rst_l_en_o,
    .cio_key0_out_en_o,
    .cio_key1_out_en_o,
    .cio_key2_out_en_o,
    .cio_pwrb_out_en_o,
    .cio_z3_wakeup_en_o
  );


endmodule : sysrst_ctrl_tb
