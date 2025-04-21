// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module usbdev_bind_fpv;


  bind usbdev usbdev_assert_fpv #(
    .Stub(Stub),
    .AlertAsyncOn(AlertAsyncOn),
    .RcvrWakeTimeUs(RcvrWakeTimeUs)
  ) i_usbdev_assert_fpv (
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


endmodule : usbdev_bind_fpv
