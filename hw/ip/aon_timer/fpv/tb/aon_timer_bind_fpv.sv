// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module aon_timer_bind_fpv;


  bind aon_timer aon_timer_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_aon_timer_assert_fpv (
    .clk_i,
    .clk_aon_i,
    .rst_ni,
    .rst_aon_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .lc_escalate_en_i,
    .intr_wkup_timer_expired_o,
    .intr_wdog_timer_bark_o,
    .nmi_wdog_timer_bark_o,
    .wkup_req_o,
    .aon_timer_rst_req_o,
    .sleep_mode_i
  );


  bind aon_timer tlul_assert #(
    .EndpointType("Device")
  ) i_tlul_assert_device (
    .clk_i,
    .rst_ni,
    .h2d  (tl_i),
    .d2h  (tl_o),
    .*
  );

  bind aon_timer aon_timer_csr_assert_fpv i_aon_timer_csr_assert_fpv (
    .clk_i,
    .rst_ni,
    .h2d    (tl_i),
    .d2h    (tl_o)
  );

endmodule : aon_timer_bind_fpv
