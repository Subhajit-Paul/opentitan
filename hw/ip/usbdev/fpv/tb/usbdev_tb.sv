// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for usbdev.
// Intended to be used with a formal tool.

module usbdev_tb
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
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input logic cio_usb_dp_i,
  input logic cio_usb_dn_i,
  input logic usb_rx_d_i,
  output logic cio_usb_dp_o,
  output logic cio_usb_dp_en_o,
  output logic cio_usb_dn_o,
  output logic cio_usb_dn_en_o,
  output logic usb_tx_se0_o,
  output logic usb_tx_d_o,
  input logic cio_sense_i,
  output logic usb_dp_pullup_o,
  output logic usb_dn_pullup_o,
  output logic usb_rx_enable_o,
  output logic usb_tx_use_d_se0_o,
  output logic usb_aon_suspend_req_o,
  output logic usb_aon_wake_ack_o,
  input logic usb_aon_bus_reset_i,
  input logic usb_aon_sense_lost_i,
  input logic usb_aon_bus_not_idle_i,
  input logic usb_aon_wake_detect_active_i,
  output logic usb_ref_val_o,
  output logic usb_ref_pulse_o,
  input prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,
  output logic intr_pkt_received_o,
  output logic intr_pkt_sent_o,
  output logic intr_powered_o,
  output logic intr_disconnected_o,
  output logic intr_host_lost_o,
  output logic intr_link_reset_o,
  output logic intr_link_suspend_o,
  output logic intr_link_resume_o,
  output logic intr_av_out_empty_o,
  output logic intr_rx_full_o,
  output logic intr_av_overflow_o,
  output logic intr_link_in_err_o,
  output logic intr_link_out_err_o,
  output logic intr_rx_crc_err_o,
  output logic intr_rx_pid_err_o,
  output logic intr_rx_bitstuff_err_o,
  output logic intr_frame_o,
  output logic intr_av_setup_empty_o
);


  usbdev #(
    .Stub(Stub),
    .AlertAsyncOn(AlertAsyncOn),
    .RcvrWakeTimeUs(RcvrWakeTimeUs)
  ) dut (
    .clk_i,
    .rst_ni,
    .clk_aon_i,
    .rst_aon_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .cio_usb_dp_i,
    .cio_usb_dn_i,
    .usb_rx_d_i,
    .cio_usb_dp_o,
    .cio_usb_dp_en_o,
    .cio_usb_dn_o,
    .cio_usb_dn_en_o,
    .usb_tx_se0_o,
    .usb_tx_d_o,
    .cio_sense_i,
    .usb_dp_pullup_o,
    .usb_dn_pullup_o,
    .usb_rx_enable_o,
    .usb_tx_use_d_se0_o,
    .usb_aon_suspend_req_o,
    .usb_aon_wake_ack_o,
    .usb_aon_bus_reset_i,
    .usb_aon_sense_lost_i,
    .usb_aon_bus_not_idle_i,
    .usb_aon_wake_detect_active_i,
    .usb_ref_val_o,
    .usb_ref_pulse_o,
    .ram_cfg_i,
    .intr_pkt_received_o,
    .intr_pkt_sent_o,
    .intr_powered_o,
    .intr_disconnected_o,
    .intr_host_lost_o,
    .intr_link_reset_o,
    .intr_link_suspend_o,
    .intr_link_resume_o,
    .intr_av_out_empty_o,
    .intr_rx_full_o,
    .intr_av_overflow_o,
    .intr_link_in_err_o,
    .intr_link_out_err_o,
    .intr_rx_crc_err_o,
    .intr_rx_pid_err_o,
    .intr_rx_bitstuff_err_o,
    .intr_frame_o,
    .intr_av_setup_empty_o
  );


endmodule : usbdev_tb
