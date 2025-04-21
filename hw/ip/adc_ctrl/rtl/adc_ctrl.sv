// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// adc_ctrl module

`include "prim_assert.sv"

module adc_ctrl
  import adc_ctrl_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input clk_i,      // regular core clock for SW config interface
  input clk_aon_i,  // always-on slow clock for internal logic
  input rst_ni,     // power-on hardware reset
  input rst_aon_ni, // power-on reset for the 200KHz clock(logic)

  // Regster interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  // Inter-module IO, AST interface
  // .pd: Power down ADC (used in deep sleep mode to save power)
  // .channel_sel: channel select for ADC;
  // 2'b0 means stop, 2'b01 means first channel, 2'b10 means second channel, 2'b11 illegal
  output ast_pkg::adc_ast_req_t adc_o,
  // .data: ADC voltage level, each step is 2.148mV(2200mV/1024). It covers 0-2.2V
  // .data_valid: Valid bit(pulse) for adc_d
  input  ast_pkg::adc_ast_rsp_t adc_i,

  // Interrupt indicates a matching or measurement is done
  output logic intr_match_pending_o,

  // Pwrmgr interface
  // Debug cable is detected; wake up the chip in normal sleep and deep sleep mode
  output logic wkup_req_o
);

  adc_ctrl_reg2hw_t reg2hw;
  adc_ctrl_hw2reg_t hw2reg;

  // Alerts
  logic [NumAlerts-1:0] alert_test, alerts;
  assign alert_test = {reg2hw.alert_test.q & reg2hw.alert_test.qe};

  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(1'b1)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni,
      .alert_test_i (alert_test[i]),
      .alert_req_i  (alerts[0]),
      .alert_ack_o  (),
      .alert_state_o(),
      .alert_rx_i   (alert_rx_i[i]),
      .alert_tx_o   (alert_tx_o[i])
    );
  end

  // Register module
  adc_ctrl_reg_top u_reg (
    .clk_i,
    .rst_ni,
    .clk_aon_i,
    .rst_aon_ni,
    .tl_i(tl_i),
    .tl_o(tl_o),
    .reg2hw(reg2hw),
    .hw2reg(hw2reg),
    // SEC_CM: BUS.INTEGRITY
    .intg_err_o(alerts[0])
  );

  // Instantiate DCD core module
  adc_ctrl_core u_adc_ctrl_core (
    .clk_aon_i(clk_aon_i),
    .rst_aon_ni(rst_aon_ni),
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .reg2hw_i(reg2hw),
    .intr_state_o(hw2reg.intr_state),
    .adc_chn_val_o(hw2reg.adc_chn_val),
    .adc_intr_status_o(hw2reg.adc_intr_status),
    .aon_filter_status_o(hw2reg.filter_status),
    .wkup_req_o,
    .intr_o(intr_match_pending_o),
    .adc_i(adc_i),
    .adc_o(adc_o),
    .aon_fsm_state_o(hw2reg.adc_fsm_state.d)
  );

  // All outputs should be known value after reset
  `ASSERT_KNOWN(IntrKnown, intr_match_pending_o)
  `ASSERT_KNOWN(WakeKnown, wkup_req_o)
  `ASSERT_KNOWN(TlODValidKnown, tl_o.d_valid)
  `ASSERT_KNOWN(TlOAReadyKnown, tl_o.a_ready)
  `ASSERT_KNOWN(AdcKnown_A, adc_o)
  `ASSERT_KNOWN(AlertsKnown_A, alert_tx_o)

  // Alert assertions for reg_we onehot check
  `ASSERT_PRIM_REG_WE_ONEHOT_ERROR_TRIGGER_ALERT(RegWeOnehotCheck_A, u_reg, alert_tx_o[0])
  //////////////////////////////////////////////  // Assertions, Assumptions, and Coverpoints //  //////////////////////////////////////////////

// LLM

// Helper logic
logic [7:0] pwrup_counter;
logic [7:0] prev_filter_hits;
logic sampling_started;
logic first_interrupt;

// Counter for power-up sequence
always_ff @(posedge clk_aon_i or negedge rst_aon_ni) begin
    if (!rst_aon_ni) begin
        pwrup_counter <= '0;
    end else if (adc_o.pd) begin
        pwrup_counter <= '0;
    end else if (!sampling_started) begin
        pwrup_counter <= pwrup_counter + 1'b1;
    end
end

// Track previous filter hits for debounce checking
always_ff @(posedge clk_aon_i or negedge rst_aon_ni) begin
    if (!rst_aon_ni) begin
        prev_filter_hits <= '0;
    end else begin
        prev_filter_hits <= hw2reg.filter_status.d;
    end
end

// Track first interrupt occurrence
always_ff @(posedge clk_aon_i or negedge rst_aon_ni) begin
    if (!rst_aon_ni) begin
        first_interrupt <= 1'b0;
    end else if (intr_match_pending_o) begin
        first_interrupt <= 1'b1;
    end
end

// Property: Power Up Sequence
property power_up_sequence;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (!adc_o.pd) |-> (##[0:pwrup_time] sampling_started);
endproperty
POWER_UP_SEQ: assert property(power_up_sequence);

// Property: Channel Sampling Sequence
property channel_sampling_sequence;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (adc_o.channel_sel == 2'b10) |-> $past(adc_o.channel_sel == 2'b01);
endproperty
CHANNEL_SAMPLING_SEQ: assert property(channel_sampling_sequence);

// Property: Channel Select Protocol
property channel_select_protocol;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    ($changed(adc_o.channel_sel)) |-> $past(adc_o.channel_sel == 2'b00);
endproperty
CHANNEL_SELECT_PROT: assert property(channel_select_protocol);

// Property: Sample Storage
property sample_storage;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (adc_i.data_valid) |-> ##1 $changed(hw2reg.adc_chn_val);
endproperty
SAMPLE_STORAGE: assert property(sample_storage);

// Property: Filter Range Inside Check
property filter_range_inside;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (reg2hw.filter_cfg[0].min_v <= adc_i.data && adc_i.data <= reg2hw.filter_cfg[0].max_v) |-> 
    hw2reg.filter_status.d[0];
endproperty
FILTER_RANGE_INSIDE: assert property(filter_range_inside);

// Property: Filter Range Outside Check
property filter_range_outside;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (adc_i.data < reg2hw.filter_cfg[1].min_v || adc_i.data > reg2hw.filter_cfg[1].max_v) |->
    hw2reg.filter_status.d[1];
endproperty
FILTER_RANGE_OUTSIDE: assert property(filter_range_outside);

// Property: Debounce Counter Reset
property debounce_counter_reset;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (hw2reg.filter_status.d != prev_filter_hits) |=> (debounce_cntr == '0);
endproperty
DEBOUNCE_CNT_RESET: assert property(debounce_counter_reset);

// Property: Debounce Counter Increment
property debounce_counter_increment;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (hw2reg.filter_status.d == prev_filter_hits && |hw2reg.filter_status.d) |=>
    (debounce_cntr == $past(debounce_cntr) + 1'b1);
endproperty
DEBOUNCE_CNT_INC: assert property(debounce_counter_increment);

// Property: Interrupt Generation
property interrupt_generation;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (debounce_cntr == reg2hw.np_sample_cnt.q) |-> intr_match_pending_o;
endproperty
INTERRUPT_GEN: assert property(interrupt_generation);

// Property: Wakeup Generation
property wakeup_generation;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (|(hw2reg.filter_status.d & reg2hw.adc_wakeup_ctl.q)) |-> wkup_req_o;
endproperty
WAKEUP_GEN: assert property(wakeup_generation);

// Property: Value Interrupt Capture
property value_interrupt_capture;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    (intr_match_pending_o && !first_interrupt) |-> ##1 $stable(hw2reg.adc_chn_val);
endproperty
VALUE_INTERRUPT_CAPTURE: assert property(value_interrupt_capture);

// Property: Filter Status Update
property filter_status_update;
    @(posedge clk_aon_i) disable iff (!rst_aon_ni)
    $changed(hw2reg.filter_status.d) |-> 
    (!reg2hw.filter_status_clr.q || reg2hw.filter_status_clr.qe);
endproperty
FILTER_STATUS_UPDATE: assert property(filter_status_update);

// LLM

endmodule

