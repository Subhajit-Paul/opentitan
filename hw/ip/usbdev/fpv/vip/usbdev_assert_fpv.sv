// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for usbdev.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module usbdev_assert_fpv
  import usbdev_pkg::*;
  import usbdev_reg_pkg::*;
  import prim_util_pkg::vbits;
#(
  parameter bit Stub = 1'b0,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter int unsigned RcvrWakeTimeUs = 1
) (
  input logic clk_i,
  input logic rst_ni,
  input logic clk_aon_i,
  input logic rst_aon_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input logic cio_usb_dp_i,
  input logic cio_usb_dn_i,
  input logic usb_rx_d_i,
  input logic cio_usb_dp_o,
  input logic cio_usb_dp_en_o,
  input logic cio_usb_dn_o,
  input logic cio_usb_dn_en_o,
  input logic usb_tx_se0_o,
  input logic usb_tx_d_o,
  input logic cio_sense_i,
  input logic usb_dp_pullup_o,
  input logic usb_dn_pullup_o,
  input logic usb_rx_enable_o,
  input logic usb_tx_use_d_se0_o,
  input logic usb_aon_suspend_req_o,
  input logic usb_aon_wake_ack_o,
  input logic usb_aon_bus_reset_i,
  input logic usb_aon_sense_lost_i,
  input logic usb_aon_bus_not_idle_i,
  input logic usb_aon_wake_detect_active_i,
  input logic usb_ref_val_o,
  input logic usb_ref_pulse_o,
  input prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,
  input logic intr_pkt_received_o,
  input logic intr_pkt_sent_o,
  input logic intr_powered_o,
  input logic intr_disconnected_o,
  input logic intr_host_lost_o,
  input logic intr_link_reset_o,
  input logic intr_link_suspend_o,
  input logic intr_link_resume_o,
  input logic intr_av_out_empty_o,
  input logic intr_rx_full_o,
  input logic intr_av_overflow_o,
  input logic intr_link_in_err_o,
  input logic intr_link_out_err_o,
  input logic intr_rx_crc_err_o,
  input logic intr_rx_pid_err_o,
  input logic intr_rx_bitstuff_err_o,
  input logic intr_frame_o,
  input logic intr_av_setup_empty_o
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

endmodule : usbdev_assert_fpv
