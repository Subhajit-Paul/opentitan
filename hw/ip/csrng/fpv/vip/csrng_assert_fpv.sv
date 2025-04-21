// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for csrng.
// Intended to be used with a formal tool.

`include "prim_assert.sv"

module csrng_assert_fpv
  import csrng_pkg::*;
  import csrng_reg_pkg::*;
#(
  parameter aes_pkg::sbox_impl_e SBoxImpl = aes_pkg::SBoxImplCanright,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter int NHwApps = 2,
  parameter cs_keymgr_div_t RndCnstCsKeymgrDivNonProduction = CsKeymgrDivWidth'(0),
  parameter cs_keymgr_div_t RndCnstCsKeymgrDivProduction = CsKeymgrDivWidth'(0)
) (
  input logic clk_i,
  input logic rst_ni,
  input tlul_pkg::tl_h2d_t tl_i,
  input tlul_pkg::tl_d2h_t tl_o,
  input prim_mubi_pkg::mubi8_t otp_en_csrng_sw_app_read_i,
  input lc_ctrl_pkg::lc_tx_t lc_hw_debug_en_i,
  input entropy_src_pkg::entropy_src_hw_if_req_t entropy_src_hw_if_o,
  input entropy_src_pkg::entropy_src_hw_if_rsp_t entropy_src_hw_if_i,
  input entropy_src_pkg::cs_aes_halt_req_t cs_aes_halt_i,
  input entropy_src_pkg::cs_aes_halt_rsp_t cs_aes_halt_o,
  input csrng_req_t[NHwApps-1:0] csrng_cmd_i,
  input csrng_rsp_t[NHwApps-1:0] csrng_cmd_o,
  input prim_alert_pkg::alert_rx_t[NumAlerts-1:0] alert_rx_i,
  input prim_alert_pkg::alert_tx_t[NumAlerts-1:0] alert_tx_o,
  input logic intr_cs_cmd_req_done_o,
  input logic intr_cs_entropy_req_o,
  input logic intr_cs_hw_inst_exc_o,
  input logic intr_cs_fatal_err_o
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

endmodule : csrng_assert_fpv
