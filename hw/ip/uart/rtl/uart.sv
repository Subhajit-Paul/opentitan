// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: UART top level wrapper file

`include "prim_assert.sv"

module uart
    import uart_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  input           clk_i,
  input           rst_ni,

  // Bus Interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  output logic    lsio_trigger_o,

  // Generic IO
  input           cio_rx_i,
  output logic    cio_tx_o,
  output logic    cio_tx_en_o,

  // Interrupts
  output logic    intr_tx_watermark_o ,
  output logic    intr_tx_empty_o ,
  output logic    intr_rx_watermark_o ,
  output logic    intr_tx_done_o  ,
  output logic    intr_rx_overflow_o  ,
  output logic    intr_rx_frame_err_o ,
  output logic    intr_rx_break_err_o ,
  output logic    intr_rx_timeout_o   ,
  output logic    intr_rx_parity_err_o
);

  logic [NumAlerts-1:0] alert_test, alerts;
  uart_reg2hw_t reg2hw;
  uart_hw2reg_t hw2reg;

  uart_reg_top u_reg (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .reg2hw,
    .hw2reg,
    // SEC_CM: BUS.INTEGRITY
    .intg_err_o (alerts[0])
  );

  uart_core uart_core (
    .clk_i,
    .rst_ni,
    .reg2hw,
    .hw2reg,

    .rx    (cio_rx_i   ),
    .tx    (cio_tx_o   ),

    .lsio_trigger_o,

    .intr_tx_watermark_o,
    .intr_tx_empty_o,
    .intr_rx_watermark_o,
    .intr_tx_done_o,
    .intr_rx_overflow_o,
    .intr_rx_frame_err_o,
    .intr_rx_break_err_o,
    .intr_rx_timeout_o,
    .intr_rx_parity_err_o
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

  // always enable the driving out of TX
  assign cio_tx_en_o = 1'b1;

  // Assert Known for outputs
  `ASSERT(TxEnIsOne_A, cio_tx_en_o === 1'b1)
  `ASSERT_KNOWN(TxKnown_A, cio_tx_o, clk_i, !rst_ni || !cio_tx_en_o)

  // Assert Known for alerts
  `ASSERT_KNOWN(AlertsKnown_A, alert_tx_o)

  // Assert Known for interrupts
  `ASSERT_KNOWN(TxWatermarkKnown_A, intr_tx_watermark_o)
  `ASSERT_KNOWN(TxEmptyKnown_A, intr_tx_empty_o)
  `ASSERT_KNOWN(RxWatermarkKnown_A, intr_rx_watermark_o)
  `ASSERT_KNOWN(TxDoneKnown_A, intr_tx_done_o)
  `ASSERT_KNOWN(RxOverflowKnown_A, intr_rx_overflow_o)
  `ASSERT_KNOWN(RxFrameErrKnown_A, intr_rx_frame_err_o)
  `ASSERT_KNOWN(RxBreakErrKnown_A, intr_rx_break_err_o)
  `ASSERT_KNOWN(RxTimeoutKnown_A, intr_rx_timeout_o)
  `ASSERT_KNOWN(RxParityErrKnown_A, intr_rx_parity_err_o)

  // Alert assertions for reg_we onehot check
  `ASSERT_PRIM_REG_WE_ONEHOT_ERROR_TRIGGER_ALERT(RegWeOnehotCheck_A, u_reg, alert_tx_o[0])
// AUTO-GENERATED ASSERTIONS START

// Helper logic
logic [7:0] tx_data_reg;      // Register to track transmitted data
logic [5:0] tx_fifo_level;    // TX FIFO level counter
logic [6:0] rx_fifo_level;    // RX FIFO level counter
logic [3:0] bit_counter;      // Bit counter for transmission
logic tx_active;              // TX is currently sending data
logic rx_active;              // RX is currently receiving data

// Additional helper logic declarations
logic [3:0] rx_sample_cnt;    // RX sampling counter
logic rx_start_detect;        // RX start bit detection flag
logic tick_baud;             // Baud rate tick
logic [15:0] baud_counter;   // Baud rate counter for NCO
logic [7:0] break_cnt;       // Break condition counter
logic [7:0] rx_data_reg;     // RX data register
logic rx_valid;              // RX valid indication
logic [23:0] timeout_cnt;    // Timeout counter

// CHK12: Baud Rate Generation (corrected register field access)
property uart_baud_rate;
    @(posedge clk_i) disable iff (!rst_ni)
    (reg2hw.ctrl.nco.q != 0) |-> 
    (tick_baud == (baud_counter >= reg2hw.ctrl.nco.q));
endproperty
UART_BAUD_RATE: assert property(uart_baud_rate);

// AUTO-GENERATED ASSERTIONS END


endmodule
