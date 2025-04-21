// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng top level wrapper file

`include "prim_assert.sv"

module csrng
 import csrng_pkg::*;
 import csrng_reg_pkg::*;
#(
  parameter aes_pkg::sbox_impl_e SBoxImpl = aes_pkg::SBoxImplCanright,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter int NHwApps = 2,
  parameter cs_keymgr_div_t RndCnstCsKeymgrDivNonProduction = CsKeymgrDivWidth'(0),
  parameter cs_keymgr_div_t RndCnstCsKeymgrDivProduction = CsKeymgrDivWidth'(0)
) (
  input logic         clk_i,
  input logic         rst_ni,

  // Tilelink Bus Interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

   // OTP Interface
  // SEC_CM: INTERSIG.MUBI
  input  prim_mubi_pkg::mubi8_t otp_en_csrng_sw_app_read_i,

  // Lifecycle broadcast inputs
  input  lc_ctrl_pkg::lc_tx_t  lc_hw_debug_en_i,

  // Entropy Interface
  output entropy_src_pkg::entropy_src_hw_if_req_t entropy_src_hw_if_o,
  input  entropy_src_pkg::entropy_src_hw_if_rsp_t entropy_src_hw_if_i,

  // Entropy Interface
  input  entropy_src_pkg::cs_aes_halt_req_t cs_aes_halt_i,
  output entropy_src_pkg::cs_aes_halt_rsp_t cs_aes_halt_o,

  // Application Interfaces
  input  csrng_req_t  [NHwApps-1:0] csrng_cmd_i,
  output csrng_rsp_t  [NHwApps-1:0] csrng_cmd_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  // Interrupts
  output logic    intr_cs_cmd_req_done_o,
  output logic    intr_cs_entropy_req_o,
  output logic    intr_cs_hw_inst_exc_o,
  output logic    intr_cs_fatal_err_o
);

  csrng_reg2hw_t reg2hw;
  csrng_hw2reg_t hw2reg;

  logic [NumAlerts-1:0] alert_test;
  logic [NumAlerts-1:0] alert;

  logic [NumAlerts-1:0] intg_err_alert;
  assign intg_err_alert[0] = 1'b0;

  // SEC_CM: CONFIG.REGWEN
  // SEC_CM: TILE_LINK.BUS.INTEGRITY

  csrng_reg_top u_reg (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .reg2hw,
    .hw2reg,
    .intg_err_o(intg_err_alert[1])
  );

  csrng_core #(
    .SBoxImpl(SBoxImpl),
    .NHwApps(NHwApps),
    .RndCnstCsKeymgrDivNonProduction(RndCnstCsKeymgrDivNonProduction),
    .RndCnstCsKeymgrDivProduction(RndCnstCsKeymgrDivProduction)
  ) u_csrng_core (
    .clk_i,
    .rst_ni,
    .reg2hw,
    .hw2reg,

    // misc inputs
    .otp_en_csrng_sw_app_read_i(otp_en_csrng_sw_app_read_i),
    .lc_hw_debug_en_i,

    // Entropy Interface
    .entropy_src_hw_if_o,
    .entropy_src_hw_if_i,

    // Entropy Interface
    .cs_aes_halt_i,
    .cs_aes_halt_o,

    // Application Interfaces
    .csrng_cmd_i,
    .csrng_cmd_o,

    // Alerts
    .recov_alert_test_o(alert_test[0]),
    .fatal_alert_test_o(alert_test[1]),
    .recov_alert_o(alert[0]),
    .fatal_alert_o(alert[1]),

    .intr_cs_cmd_req_done_o,
    .intr_cs_entropy_req_o,
    .intr_cs_hw_inst_exc_o,
    .intr_cs_fatal_err_o
  );


  ///////////////////////////
  // Alert generation
  ///////////////////////////
  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(i)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni,
      .alert_test_i  ( alert_test[i]                 ),
      .alert_req_i   ( alert[i] || intg_err_alert[i] ),
      .alert_ack_o   (                               ),
      .alert_state_o (                               ),
      .alert_rx_i    ( alert_rx_i[i]                 ),
      .alert_tx_o    ( alert_tx_o[i]                 )
    );
  end


  // Assertions

  `ASSERT_KNOWN(TlDValidKnownO_A, tl_o.d_valid)
  `ASSERT_KNOWN(TlAReadyKnownO_A, tl_o.a_ready)
  `ASSERT_KNOWN(EsReqKnownO_A, entropy_src_hw_if_o.es_req)

  // Application Interface Asserts
  for (genvar i = 0; i < NHwApps; i = i+1) begin : gen_app_if_asserts
    `ASSERT_KNOWN(CsrngReqReadyKnownO_A, csrng_cmd_o[i].csrng_req_ready)
    `ASSERT_KNOWN(CsrngRspAckKnownO_A, csrng_cmd_o[i].csrng_rsp_ack)
    `ASSERT_KNOWN(CsrngRspStsKnownO_A, csrng_cmd_o[i].csrng_rsp_sts)
    `ASSERT_KNOWN(CsrngGenbitsValidKnownO_A, csrng_cmd_o[i].genbits_valid)
    `ASSERT_KNOWN_IF(CsrngGenbitsFipsKnownO_A, csrng_cmd_o[i].genbits_fips,
        csrng_cmd_o[i].genbits_valid)
    `ASSERT_KNOWN_IF(CsrngGenbitsBusKnownO_A, csrng_cmd_o[i].genbits_bus,
        csrng_cmd_o[i].genbits_valid)
  end : gen_app_if_asserts

  // Alerts
  `ASSERT_KNOWN(AlertTxKnownO_A, alert_tx_o)

  `ASSERT_KNOWN(IntrCsCmdReqDoneKnownO_A, intr_cs_cmd_req_done_o)
  `ASSERT_KNOWN(IntrCsEntropyReqKnownO_A, intr_cs_entropy_req_o)
  `ASSERT_KNOWN(IntrCsHwInstExcKnownO_A, intr_cs_hw_inst_exc_o)
  `ASSERT_KNOWN(IntrCsFatalErrKnownO_A, intr_cs_fatal_err_o)

  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(CtrDrbgUpdAlertCheck_A,
    u_csrng_core.u_csrng_ctr_drbg_upd.u_prim_count_ctr_drbg,
    alert_tx_o[1])

  `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(CtrDrbgGenAlertCheck_A,
    u_csrng_core.u_csrng_ctr_drbg_gen.u_prim_count_ctr_drbg,
    alert_tx_o[1])

  for (genvar i = 0; i < NHwApps + 1; i++) begin : gen_cnt_asserts
    `ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(CntAlertCheck_A,
      u_csrng_core.gen_cmd_stage[i].u_csrng_cmd_stage.u_prim_count_cmd_gen_cntr,
      alert_tx_o[1])

    `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(DrbgCmdFsmCheck_A,
      u_csrng_core.gen_cmd_stage[i].u_csrng_cmd_stage.u_state_regs,
      alert_tx_o[1])
  end

  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(CtrlMainFsmCheck_A,
    u_csrng_core.u_csrng_main_sm.u_state_regs,
    alert_tx_o[1])

  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(DrbgGenFsmCheck_A,
    u_csrng_core.u_csrng_ctr_drbg_gen.u_state_regs,
    alert_tx_o[1])

  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(DrbgUpdBlkEncFsmCheck_A,
    u_csrng_core.u_csrng_ctr_drbg_upd.u_blk_enc_state_regs,
    alert_tx_o[1])

  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(DrbgUpdOutBlkFsmCheck_A,
    u_csrng_core.u_csrng_ctr_drbg_upd.u_outblk_state_regs,
    alert_tx_o[1])

  for (genvar i = 0; i < aes_pkg::Sp2VWidth; i++) begin : gen_aes_cipher_control_fsm_svas
    if (aes_pkg::SP2V_LOGIC_HIGH[i] == 1'b1) begin : gen_aes_cipher_control_fsm_svas_p
      `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(AesCipherControlFsmCheck_A,
          u_csrng_core.u_csrng_block_encrypt.u_aes_cipher_core.u_aes_cipher_control.gen_fsm[i].
              gen_fsm_p.u_aes_cipher_control_fsm_i.u_aes_cipher_control_fsm.u_state_regs,
          alert_tx_o[1])
    end else begin : gen_aes_cipher_control_fsm_svas_n
      `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(AesCipherControlFsmCheck_A,
          u_csrng_core.u_csrng_block_encrypt.u_aes_cipher_core.u_aes_cipher_control.gen_fsm[i].
              gen_fsm_n.u_aes_cipher_control_fsm_i.u_aes_cipher_control_fsm.u_state_regs,
          alert_tx_o[1])
    end
  end

  // Alert assertions for reg_we onehot check
  `ASSERT_PRIM_REG_WE_ONEHOT_ERROR_TRIGGER_ALERT(RegWeOnehotCheck_A, u_reg, alert_tx_o[1])
// AUTO-GENERATED ASSERTIONS START

// Inside csrng.sv, after the module definition

// Helper logic
logic [3:0] cmd_type;
assign cmd_type = csrng_cmd_i[0].csrng_req_bus[3:0];

// First, define all properties
property cmd_valid_stable;
  @(posedge clk_i) disable iff (!rst_ni)
  csrng_cmd_i[0].csrng_req_valid && !csrng_cmd_o[0].csrng_req_ready |=> 
  $stable(csrng_cmd_i[0].csrng_req_valid) && $stable(csrng_cmd_i[0].csrng_req_bus);
endproperty

property cmd_rsp_ack_one_cycle;
  @(posedge clk_i) disable iff (!rst_ni)
  csrng_cmd_o[0].csrng_rsp_ack |=> !csrng_cmd_o[0].csrng_rsp_ack;
endproperty

property genbits_handshake;
  @(posedge clk_i) disable iff (!rst_ni)
  csrng_cmd_o[0].genbits_valid && csrng_cmd_i[0].genbits_ready |=> 
  !csrng_cmd_o[0].genbits_valid;
endproperty

// Then, declare all assertions and covers
// Assertion declarations
CHK1_CmdValidStable: assert property(cmd_valid_stable);
CHK2_RspAckOneCycle: assert property(cmd_rsp_ack_one_cycle);
CHK3_GenbitsHandshake: assert property(genbits_handshake);

// Coverage declarations
COV1_CmdValidStable: cover property(cmd_valid_stable);
COV2_RspAckOneCycle: cover property(cmd_rsp_ack_one_cycle);
COV3_GenbitsHandshake: cover property(genbits_handshake);

// AUTO-GENERATED ASSERTIONS END

endmodule
