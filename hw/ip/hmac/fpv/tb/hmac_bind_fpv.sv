// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module hmac_bind_fpv;


  bind hmac hmac_assert_fpv #(
    .AlertAsyncOn(AlertAsyncOn)
  ) i_hmac_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .intr_hmac_done_o,
    .intr_fifo_empty_o,
    .intr_hmac_err_o,
    .idle_o
  );


  bind hmac tlul_assert #(
    .EndpointType("Device")
  ) i_tlul_assert_device (
    .clk_i,
    .rst_ni,
    .h2d  (tl_i),
    .d2h  (tl_o),
    .*
  );

  bind hmac hmac_csr_assert_fpv i_hmac_csr_assert_fpv (
    .clk_i,
    .rst_ni,
    .h2d    (tl_i),
    .d2h    (tl_o)
  );

endmodule : hmac_bind_fpv
