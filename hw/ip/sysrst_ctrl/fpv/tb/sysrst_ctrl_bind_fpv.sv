// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module sysrst_ctrl_bind_fpv;


  bind sysrst_ctrl sysrst_ctrl_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_sysrst_ctrl_assert_fpv (
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


endmodule : sysrst_ctrl_bind_fpv
