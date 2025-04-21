// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module rv_timer_bind_fpv;


  bind rv_timer rv_timer_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_rv_timer_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .intr_timer_expired_hart0_timer0_o
  );


endmodule : rv_timer_bind_fpv
