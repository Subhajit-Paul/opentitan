// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module edn_bind_fpv;


  bind edn edn_assert_fpv #(
    .NumEndPoints(NumEndPoints),
    .AlertAsyncOn(AlertAsyncOn)
  ) i_edn_assert_fpv (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .edn_i,
    .edn_o,
    .csrng_cmd_o,
    .csrng_cmd_i,
    .alert_rx_i,
    .alert_tx_o,
    .intr_edn_cmd_req_done_o,
    .intr_edn_fatal_err_o
  );


endmodule : edn_bind_fpv
