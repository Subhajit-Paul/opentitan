// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for pattgen.
// Intended to be used with a formal tool.

module pattgen_tb
  import pattgen_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input  clk_i,
  input  rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  output logic cio_pda0_tx_o,
  output logic cio_pcl0_tx_o,
  output logic cio_pda1_tx_o,
  output logic cio_pcl1_tx_o,
  output logic cio_pda0_tx_en_o,
  output logic cio_pcl0_tx_en_o,
  output logic cio_pda1_tx_en_o,
  output logic cio_pcl1_tx_en_o,
  output logic intr_done_ch0_o,
  output logic intr_done_ch1_o
);


  pattgen #(
    .AlertAsyncOn(AlertAsyncOn)
  ) dut (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .alert_rx_i,
    .alert_tx_o,
    .cio_pda0_tx_o,
    .cio_pcl0_tx_o,
    .cio_pda1_tx_o,
    .cio_pcl1_tx_o,
    .cio_pda0_tx_en_o,
    .cio_pcl0_tx_en_o,
    .cio_pda1_tx_en_o,
    .cio_pcl1_tx_en_o,
    .intr_done_ch0_o,
    .intr_done_ch1_o
  );


endmodule : pattgen_tb
