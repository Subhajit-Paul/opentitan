// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for rom_ctrl.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module rom_ctrl_assert_fpv
  import rom_ctrl_reg_pkg::NumAlerts;
  import prim_rom_pkg::rom_cfg_t;
#(
  parameter  BootRomInitFile = "",
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter bit [63:0] RndCnstScrNonce = '0,
  parameter bit [127:0] RndCnstScrKey = '0,
  parameter int MemSizeRom = 32'h8000,
  parameter bit SecDisableScrambling = 1'b0
) (
  input  clk_i,
  input  rst_ni,
  input rom_cfg_t rom_cfg_i,
  input tlul_pkg::tl_h2d_t rom_tl_i,
  input tlul_pkg::tl_d2h_t rom_tl_o,
  input tlul_pkg::tl_h2d_t regs_tl_i,
  input tlul_pkg::tl_d2h_t regs_tl_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input rom_ctrl_pkg::pwrmgr_data_t pwrmgr_data_o,
  input rom_ctrl_pkg::keymgr_data_t keymgr_data_o,
  input kmac_pkg::app_rsp_t kmac_data_i,
  input kmac_pkg::app_req_t kmac_data_o
);

  ///////////////////////////////
  // Declarations & Parameters //
  ///////////////////////////////

  /////////////////
  // Assumptions //
  /////////////////

  // `ASSUME(MyAssumption_M, ...)

  ////////////////////////
  // Forward Assertions //
  ////////////////////////

  // `ASSERT(MyFwdAssertion_A, ...)

  /////////////////////////
  // Backward Assertions //
  /////////////////////////

  // `ASSERT(MyBkwdAssertion_A, ...)

endmodule : rom_ctrl_assert_fpv
