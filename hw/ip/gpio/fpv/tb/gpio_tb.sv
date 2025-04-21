// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for gpio.
// Intended to be used with a formal tool.

module gpio_tb
  import gpio_pkg::*;
  import gpio_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter bit GpioAsHwStrapsEn = 1,
  parameter bit GpioAsyncOn = 1
) (
  input  clk_i,
  input  rst_ni,
  input  strap_en_i,
  output gpio_straps_t sampled_straps_o,
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  output logic[31:0] intr_gpio_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input [31:0] cio_gpio_i,
  output logic[31:0] cio_gpio_o,
  output logic[31:0] cio_gpio_en_o
);


  gpio #(
    .AlertAsyncOn(AlertAsyncOn),
    .GpioAsHwStrapsEn(GpioAsHwStrapsEn),
    .GpioAsyncOn(GpioAsyncOn)
  ) dut (
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


endmodule : gpio_tb
