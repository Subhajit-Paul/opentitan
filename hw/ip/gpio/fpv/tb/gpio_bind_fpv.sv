// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module gpio_bind_fpv;


  bind gpio gpio_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn),
    .GpioAsHwStrapsEn(GpioAsHwStrapsEn),
    .GpioAsyncOn(GpioAsyncOn)
  ) i_gpio_assert_fpv (
    .clk_i,
    .rst_ni,
    .strap_en_i,
    .sampled_straps_o,
    .tl_i,
    .tl_o,
    .intr_gpio_o,
    .alert_rx_i,
    .alert_tx_o,
    .cio_gpio_i,
    .cio_gpio_o,
    .cio_gpio_en_o
  );


endmodule : gpio_bind_fpv
