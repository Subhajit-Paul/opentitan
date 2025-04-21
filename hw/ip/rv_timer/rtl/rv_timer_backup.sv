// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//


`include "prim_assert.sv"

module rv_timer import rv_timer_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  output logic intr_timer_expired_hart0_timer0_o
);

  rv_timer_reg2hw_t reg2hw;
  rv_timer_hw2reg_t hw2reg;

  logic [N_HARTS-1:0] active;

  logic [11:0] prescaler [N_HARTS];
  logic [7:0]  step      [N_HARTS];

  logic [N_HARTS-1:0] tick;

  logic [63:0] mtime_d  [N_HARTS];
  logic [63:0] mtime    [N_HARTS];
  logic [63:0] mtimecmp [N_HARTS][N_TIMERS]; // Only [harts][0] is connected to mtimecmp CSRs
  logic        mtimecmp_update [N_HARTS][N_TIMERS];

  logic [N_HARTS*N_TIMERS-1:0] intr_timer_set;
  logic [N_HARTS*N_TIMERS-1:0] intr_timer_en;
  logic [N_HARTS*N_TIMERS-1:0] intr_timer_test_q;
  logic [N_HARTS-1:0]          intr_timer_test_qe;
  logic [N_HARTS*N_TIMERS-1:0] intr_timer_state_q;
  logic [N_HARTS-1:0]          intr_timer_state_de;
  logic [N_HARTS*N_TIMERS-1:0] intr_timer_state_d;

  logic [N_HARTS*N_TIMERS-1:0] intr_out;

  /////////////////////////////////////////////////
  // Connecting register interface to the signal //
  /////////////////////////////////////////////////

  // Once reggen supports nested multireg, the following can be automated. For the moment, it must
  // be connected manually.
  assign active[0]  = reg2hw.ctrl[0].q;
  assign prescaler = '{reg2hw.cfg0.prescale.q};
  assign step      = '{reg2hw.cfg0.step.q};

  assign hw2reg.timer_v_upper0.de = tick[0];
  assign hw2reg.timer_v_lower0.de = tick[0];
  assign hw2reg.timer_v_upper0.d = mtime_d[0][63:32];
  assign hw2reg.timer_v_lower0.d = mtime_d[0][31: 0];
  assign mtime[0] = {reg2hw.timer_v_upper0.q, reg2hw.timer_v_lower0.q};
  assign mtimecmp = '{'{{reg2hw.compare_upper0_0.q,reg2hw.compare_lower0_0.q}}};
  assign mtimecmp_update[0][0] = reg2hw.compare_upper0_0.qe | reg2hw.compare_lower0_0.qe;

  assign intr_timer_expired_hart0_timer0_o = intr_out[0];
  assign intr_timer_en            = reg2hw.intr_enable0[0].q;
  assign intr_timer_state_q       = reg2hw.intr_state0[0].q;
  assign intr_timer_test_q        = reg2hw.intr_test0[0].q;
  assign intr_timer_test_qe       = reg2hw.intr_test0[0].qe;
  assign hw2reg.intr_state0[0].de = intr_timer_state_de | mtimecmp_update[0][0];
  assign hw2reg.intr_state0[0].d  = intr_timer_state_d & ~mtimecmp_update[0][0];


  for (genvar h = 0 ; h < N_HARTS ; h++) begin : gen_harts
    prim_intr_hw #(
      .Width(N_TIMERS)
    ) u_intr_hw (
      .clk_i,
      .rst_ni,
      .event_intr_i           (intr_timer_set),

      .reg2hw_intr_enable_q_i (intr_timer_en[h*N_TIMERS+:N_TIMERS]),
      .reg2hw_intr_test_q_i   (intr_timer_test_q[h*N_TIMERS+:N_TIMERS]),
      .reg2hw_intr_test_qe_i  (intr_timer_test_qe[h]),
      .reg2hw_intr_state_q_i  (intr_timer_state_q[h*N_TIMERS+:N_TIMERS]),
      .hw2reg_intr_state_de_o (intr_timer_state_de),
      .hw2reg_intr_state_d_o  (intr_timer_state_d[h*N_TIMERS+:N_TIMERS]),

      .intr_o                 (intr_out[h*N_TIMERS+:N_TIMERS])
    );

    timer_core #(
      .N (N_TIMERS)
    ) u_core (
      .clk_i,
      .rst_ni,

      .active    (active[h]),
      .prescaler (prescaler[h]),
      .step      (step[h]),

      .tick      (tick[h]),

      .mtime_d   (mtime_d[h]),
      .mtime     (mtime[h]),
      .mtimecmp  (mtimecmp[h]),

      .intr      (intr_timer_set[h*N_TIMERS+:N_TIMERS])
    );
  end : gen_harts

  // Register module
  logic [NumAlerts-1:0] alert_test, alerts;
  rv_timer_reg_top u_reg (
    .clk_i,
    .rst_ni,

    .tl_i,
    .tl_o,

    .reg2hw,
    .hw2reg,

    // SEC_CM: BUS.INTEGRITY
    .intg_err_o (alerts[0])
  );

  // Alerts
  assign alert_test = {
    reg2hw.alert_test.q &
    reg2hw.alert_test.qe
  };

  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(1'b1)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni,
      .alert_test_i  ( alert_test[i] ),
      .alert_req_i   ( alerts[0]     ),
      .alert_ack_o   (               ),
      .alert_state_o (               ),
      .alert_rx_i    ( alert_rx_i[i] ),
      .alert_tx_o    ( alert_tx_o[i] )
    );
  end

  ////////////////
  // Assertions //
  ////////////////
  `ASSERT_KNOWN(TlODValidKnown, tl_o.d_valid)
  `ASSERT_KNOWN(TlOAReadyKnown, tl_o.a_ready)
  `ASSERT_KNOWN(AlertsKnown_A, alert_tx_o)
  `ASSERT_KNOWN(IntrTimerExpiredHart0Timer0Known, intr_timer_expired_hart0_timer0_o)

  // Alert assertions for reg_we onehot check
  `ASSERT_PRIM_REG_WE_ONEHOT_ERROR_TRIGGER_ALERT(RegWeOnehotCheck_A, u_reg, alert_tx_o[0])
  //////////////////////////////////////////////  // Assertions, Assumptions, and Coverpoints //  //////////////////////////////////////////////

// LLM

// Inside rv_timer module, after the existing assertions

// Helper logic for tick generator verification
logic [11:0] counter_expected [N_HARTS];
always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        counter_expected <= '{default:0};
    end else begin
        for (int i = 0; i < N_HARTS; i++) begin
            if (active[i]) begin
                if (counter_expected[i] >= prescaler[i]) begin
                    counter_expected[i] <= '0;
                end else begin
                    counter_expected[i] <= counter_expected[i] + 1'b1;
                end
            end
        end
    end
end

// CHK1: Tick Generator Operation
property tick_generator_operation_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (active[0] && counter_expected[0] == prescaler[0]) |-> tick[0];
endproperty
TICK_GENERATOR_OP_A: assert property(tick_generator_operation_p);

// CHK2: Prescaler Range Check
property prescaler_range_check_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (reg2hw.cfg0.prescale.q) |-> (reg2hw.cfg0.prescale.q <= 12'hFFF);
endproperty
PRESCALER_RANGE_A: assert property(prescaler_range_check_p);

// CHK3: Step Value Range Check
property step_value_range_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (reg2hw.cfg0.step.q) |-> (reg2hw.cfg0.step.q <= 8'hFF);
endproperty
STEP_VALUE_RANGE_A: assert property(step_value_range_p);

// CHK10: Reset Behavior
property reset_behavior_p;
    @(posedge clk_i)
        !rst_ni |-> ##1 (active == '0 && tick == '0 && 
                        mtime[0] == 64'h0 &&
                        intr_timer_set == '0);
endproperty
RESET_BEHAVIOR_A: assert property(reset_behavior_p);

// CHK4: Mtime Increment
property mtime_increment_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (tick[0] && active[0]) |=> (mtime[0] == $past(mtime[0]) + step[0]);
endproperty
MTIME_INCREMENT_A: assert property(mtime_increment_p);

// CHK5: Mtime Overflow
property mtime_overflow_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (tick[0] && active[0] && mtime[0] > (64'hFFFFFFFFFFFFFFFF - step[0])) |=>
        (mtime[0] == $past(mtime[0]) + step[0]);
endproperty
MTIME_OVERFLOW_A: assert property(mtime_overflow_p);

// CHK6: Timer Expiration
property timer_expiration_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (mtime[0] >= mtimecmp[0][0]) |-> intr_timer_set[0];
endproperty
TIMER_EXPIRATION_A: assert property(timer_expiration_p);

// CHK7: Interrupt Enable
property interrupt_enable_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (intr_timer_set[0] && intr_timer_en[0]) |-> intr_out[0];
endproperty
INTERRUPT_ENABLE_A: assert property(interrupt_enable_p);

// CHK8: Interrupt State
property interrupt_state_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (intr_timer_state_de && intr_timer_state_d[0]) |=> intr_timer_state_q[0];
endproperty
INTERRUPT_STATE_A: assert property(interrupt_state_p);

// CHK9: Register Access
property register_access_p;
    @(posedge clk_i) disable iff (!rst_ni)
        (reg2hw.ctrl[0].q || reg2hw.cfg0.prescale.q || reg2hw.cfg0.step.q ||
         reg2hw.compare_upper0_0.qe || reg2hw.compare_lower0_0.qe) |->
        (!tl_i.a_valid || tl_o.a_ready);
endproperty
REGISTER_ACCESS_A: assert property(register_access_p);

// LLM

endmodule

