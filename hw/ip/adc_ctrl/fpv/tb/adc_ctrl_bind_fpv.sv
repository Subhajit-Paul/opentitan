// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module adc_ctrl_bind_fpv;


  bind adc_ctrl adc_ctrl_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_adc_ctrl_assert_fpv (
    .clk_i,
    .clk_aon_i,
    .rst_ni,
    .rst_aon_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .adc_o,
    .adc_i,
    .intr_match_pending_o,
    .wkup_req_o
  );


endmodule : adc_ctrl_bind_fpv
