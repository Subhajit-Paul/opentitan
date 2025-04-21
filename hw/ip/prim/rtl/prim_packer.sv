// Copyright lowRISC contributors (OpenTitan project).
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Combine InW data and write to OutW data if packed to full word or stop signal

`include "prim_assert.sv"

// ICEBOX(#12958): Revise to send out the empty status.
module prim_packer #(
  parameter int unsigned InW  = 32,
  parameter int unsigned OutW = 32,

  // If 1, The input/output are byte granularity
  parameter int HintByteData = 0,

  // Turn on protect against FI for the pos variable
  parameter bit EnProtection = 1'b 0
) (
  input clk_i ,
  input rst_ni,

  input                   valid_i,
  input        [InW-1:0]  data_i,
  input        [InW-1:0]  mask_i,
  output                  ready_o,

  output logic            valid_o,
  output logic [OutW-1:0] data_o,
  output logic [OutW-1:0] mask_o,
  input                   ready_i,

  input                   flush_i,  // If 1, send out remnant and clear state
  output logic            flush_done_o,

  // When EnProtection is set, err_o raises an error case (position variable
  // mismatch)
  output logic            err_o
);

  localparam int unsigned Width    = InW + OutW;  // storage width
  localparam int unsigned ConcatW  = Width + InW; // Input concatenated width
  localparam int unsigned PtrW     = $clog2(ConcatW+1);
  localparam int unsigned IdxW     = prim_util_pkg::vbits(InW);
  localparam int unsigned OnesCntW = $clog2(InW+1);

  logic valid_next, ready_next;
  logic [Width-1:0]   stored_data, stored_mask;
  logic [ConcatW-1:0] concat_data, concat_mask;
  logic [ConcatW-1:0] shiftl_data, shiftl_mask;
  logic [InW-1:0]     shiftr_data, shiftr_mask;

  logic [PtrW-1:0]     pos_q;         // Current write position
  logic [IdxW-1:0]     lod_idx;       // result of Leading One Detector
  logic [OnesCntW-1:0] inmask_ones;   // Counting Ones for mask_i

  logic ack_in, ack_out;

  logic flush_valid; // flush data out request
  logic flush_done;
  
  // Define a local signal for assertions that need pos_d
  logic [PtrW-1:0] pos_d;

  // Computing next position ==================================================
  always_comb begin
    // counting mask_i ones
    inmask_ones = '0;
    for (int i = 0 ; i < InW ; i++) begin
      inmask_ones = inmask_ones + OnesCntW'(mask_i[i]);
    end
  end

  logic [PtrW-1:0] pos_with_input;
  assign pos_with_input = pos_q + PtrW'(inmask_ones);

  if (EnProtection == 1'b 0) begin : g_pos_nodup
    always_comb begin
      pos_d = pos_q;

      unique case ({ack_in, ack_out})
        2'b00: pos_d = pos_q;
        2'b01: pos_d = (int'(pos_q) <= OutW) ? '0 : pos_q - PtrW'(OutW);
        2'b10: pos_d = pos_with_input;
        2'b11: pos_d = (int'(pos_with_input) <= OutW) ? '0 : pos_with_input - PtrW'(OutW);
        default: pos_d = pos_q;
      endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        pos_q <= '0;
      end else if (flush_done) begin
        pos_q <= '0;
      end else begin
        pos_q <= pos_d;
      end
    end

    assign err_o = 1'b 0; // No checker logic

  end else begin : g_pos_dupcnt // EnProtection == 1'b 1
    // incr_en: Increase the pos by cnt_step. ack_in && !ack_out
    // decr_en: Decrease the pos by cnt_step. !ack_in && ack_out
    // set_en:  Set to specific value in case of ack_in && ack_out.
    //          This case, the value could be increased or descreased based on
    //          the input size (inmask_ones)
    logic            cnt_incr_en, cnt_decr_en, cnt_set_en;
    logic [PtrW-1:0] cnt_step, cnt_set;

    assign cnt_incr_en =  ack_in && !ack_out;
    assign cnt_decr_en = !ack_in &&  ack_out;
    assign cnt_set_en  =  ack_in &&  ack_out;

    // counter has underflow protection.
    assign cnt_step = (cnt_incr_en) ? PtrW'(inmask_ones) : PtrW'(OutW);

    always_comb begin : cnt_set_logic
      // default, consuming all data
      cnt_set = '0;

      if (pos_with_input > PtrW'(OutW)) begin
        // pos_q + inmask_ones is bigger than Output width. Still data remained.
        cnt_set = pos_with_input - PtrW'(OutW);
      end
    end : cnt_set_logic

    // For assertion purposes, define pos_d even in this branch
    always_comb begin
      if (cnt_set_en) begin
        pos_d = cnt_set;
      end else if (cnt_incr_en) begin
        pos_d = pos_q + PtrW'(inmask_ones);
      end else if (cnt_decr_en) begin
        pos_d = (int'(pos_q) <= OutW) ? '0 : pos_q - PtrW'(OutW);
      end else begin
        pos_d = pos_q;
      end
    end

    prim_count #(
      .Width      (PtrW),
      .ResetValue ('0  )
    ) u_pos (
      .clk_i,
      .rst_ni,

      .clr_i              (flush_done),

      .set_i              (cnt_set_en),
      .set_cnt_i          (cnt_set   ),

      .incr_en_i          (cnt_incr_en),
      .decr_en_i          (cnt_decr_en),
      .step_i             (cnt_step   ),
      .commit_i           (1'b1       ),

      .cnt_o              (pos_q     ), // Current counter state
      .cnt_after_commit_o (          ), // Next counter state

      .err_o
    );
  end // g_pos_dupcnt

  //---------------------------------------------------------------------------

  // Leading one detector for mask_i
  always_comb begin
    lod_idx = 0;
    for (int i = InW-1; i >= 0 ; i--) begin
      if (mask_i[i] == 1'b1) begin
        lod_idx = IdxW'(unsigned'(i));
      end
    end
  end

  assign ack_in  = valid_i & ready_o;
  assign ack_out = valid_o & ready_i;

  // Data process =============================================================
  //  shiftr : Input data shifted right to put the leading one at bit zero
  assign shiftr_data = (valid_i) ? data_i >> lod_idx : '0;
  assign shiftr_mask = (valid_i) ? mask_i >> lod_idx : '0;

  //  shiftl : Input data shifted into the current stored position
  assign shiftl_data = ConcatW'(shiftr_data) << pos_q;
  assign shiftl_mask = ConcatW'(shiftr_mask) << pos_q;

  // concat : Merging stored and shiftl
  assign concat_data = {{(InW){1'b0}}, stored_data & stored_mask} |
                       (shiftl_data & shiftl_mask);
  assign concat_mask = {{(InW){1'b0}}, stored_mask} | shiftl_mask;

  logic [Width-1:0] stored_data_next, stored_mask_next;

  always_comb begin
    unique case ({ack_in, ack_out})
      2'b 00: begin
        stored_data_next = stored_data;
        stored_mask_next = stored_mask;
      end
      2'b 01: begin
        // ack_out : shift the amount of OutW
        stored_data_next = {{OutW{1'b0}}, stored_data[Width-1:OutW]};
        stored_mask_next = {{OutW{1'b0}}, stored_mask[Width-1:OutW]};
      end
      2'b 10: begin
        // ack_in : Store concat data
        stored_data_next = concat_data[0+:Width];
        stored_mask_next = concat_mask[0+:Width];
      end
      2'b 11: begin
        // both : shift the concat_data
        stored_data_next = concat_data[ConcatW-1:OutW];
        stored_mask_next = concat_mask[ConcatW-1:OutW];
      end
      default: begin
        stored_data_next = stored_data;
        stored_mask_next = stored_mask;
      end
    endcase
  end

  // Store the data temporary if it doesn't exceed OutW
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      stored_data <= '0;
      stored_mask <= '0;
    end else if (flush_done) begin
      stored_data <= '0;
      stored_mask <= '0;
    end else begin
      stored_data <= stored_data_next;
      stored_mask <= stored_mask_next;
    end
  end
  //---------------------------------------------------------------------------

  // flush handling
  typedef enum logic {
    FlushIdle,
    FlushSend
  } flush_st_e;
  flush_st_e flush_st, flush_st_next;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      flush_st <= FlushIdle;
    end else begin
      flush_st <= flush_st_next;
    end
  end

  always_comb begin
    flush_st_next = FlushIdle;

    flush_valid = 1'b0;
    flush_done  = 1'b0;

    unique case (flush_st)
      FlushIdle: begin
        if (flush_i) begin
          flush_st_next = FlushSend;
        end else begin
          flush_st_next = FlushIdle;
        end
      end

      FlushSend: begin
        if (pos_q == '0) begin
          flush_st_next = FlushIdle;

          flush_valid = 1'b 0;
          flush_done  = 1'b 1;
        end else begin
          flush_st_next = FlushSend;

          flush_valid = 1'b 1;
          flush_done  = 1'b 0;
        end
      end
      default: begin
        flush_st_next = FlushIdle;

        flush_valid = 1'b 0;
        flush_done  = 1'b 0;
      end
    endcase
  end

  assign flush_done_o = flush_done;


  // Output signals ===========================================================
  assign valid_next = (int'(pos_q) >= OutW) ? 1'b 1 : flush_valid;

  // storage space is InW + OutW. So technically, ready_o can be asserted even
  // if `pos_q` is greater than OutW. But in order to do that, the logic should
  // use `inmask_ones` value whether pos_q+inmask_ones is less than (InW+OutW)
  // with `valid_i`. It creates a path from `valid_i` --> `ready_o`.
  // It may create a timing loop in some modules that use `ready_o` to
  // `valid_i` (which is not a good practice though)
  assign ready_next = int'(pos_q) <= OutW;

  // Output request
  assign valid_o = valid_next;
  assign data_o  = stored_data[OutW-1:0];
  assign mask_o  = stored_mask[OutW-1:0];

  // ready_o
  assign ready_o = ready_next;
  //---------------------------------------------------------------------------

  //////////////////////////////////////////////
  // Assertions, Assumptions, and Coverpoints //
  //////////////////////////////////////////////
  // Assumption: mask_i should be contiguous ones
  // e.g: 0011100 --> OK
  //      0100011 --> Not OK
  if (InW > 1) begin : gen_mask_assert
    `ASSUME(ContiguousOnesMask_M,
            valid_i |-> $countones(mask_i ^ {mask_i[InW-2:0],1'b0}) <= 2)
  end

  // Flush and Write Enable cannot be asserted same time
  `ASSUME(ExFlushValid_M, flush_i |-> !valid_i)

  // While in flush state, new request shouldn't come
  `ASSUME(ValidIDeassertedOnFlush_M,
          flush_st == FlushSend |-> $stable(valid_i))

  // If not acked, input port keeps asserting valid and data
  `ASSUME(DataIStable_M,
          ##1 valid_i && $past(valid_i) && !$past(ready_o)
          |-> $stable(data_i) && $stable(mask_i))

// LLM

// Helper Logic
logic valid_ready_handshake_i, valid_ready_handshake_o;
assign valid_ready_handshake_i = valid_i && ready_o;
assign valid_ready_handshake_o = valid_o && ready_i;

// Helper to check mask contiguity
function automatic logic is_mask_contiguous(logic [InW-1:0] mask);
    logic found_one, found_zero;
    found_one = 1'b0;
    found_zero = 1'b0;
    
    for(int i = InW-1; i >= 0; i--) begin
        if(mask[i] && found_zero) return 1'b0;
        if(!mask[i]) found_zero = 1'b1;
        if(mask[i]) found_one = 1'b1;
    end
    return 1'b1;
endfunction

// CHK1: Valid_Ready_Handshake_Input
property valid_ready_handshake_input_p;
    @(posedge clk_i) disable iff (!rst_ni)
    valid_ready_handshake_i |-> $stable(data_i) && $stable(mask_i);
endproperty
assert_valid_ready_handshake_input: assert property(valid_ready_handshake_input_p);

// CHK2: Valid_Ready_Handshake_Output
property valid_ready_handshake_output_p;
    @(posedge clk_i) disable iff (!rst_ni)
    valid_ready_handshake_o |-> $stable(data_o) && $stable(mask_o);
endproperty
assert_valid_ready_handshake_output: assert property(valid_ready_handshake_output_p);

// CHK3: Data_Packing_Verification
property data_packing_verification_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (valid_ready_handshake_i && pos_q == 0) |=> 
    stored_data[InW-1:0] == $past(data_i & mask_i);
endproperty
assert_data_packing_verification: assert property(data_packing_verification_p);

// CHK4: Mask_Contiguity_Check
property mask_contiguity_check_p;
    @(posedge clk_i) disable iff (!rst_ni)
    valid_i |-> is_mask_contiguous(mask_i);
endproperty
assert_mask_contiguity: assert property(mask_contiguity_check_p);

// CHK5: Output_Mask_Full
property output_mask_full_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (valid_o && !flush_valid) |-> &mask_o;
endproperty
assert_output_mask_full: assert property(output_mask_full_p);

// CHK6: Ready_Control
property ready_control_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (!ready_i && pos_q > OutW) |-> !ready_o;
endproperty
assert_ready_control: assert property(ready_control_p);

// CHK7: Flush_Operation
property flush_operation_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (flush_i && pos_q > 0) |=> valid_o;
endproperty
assert_flush_operation: assert property(flush_operation_p);

// CHK8: Flush_Done_Signal
property flush_done_signal_p;
    @(posedge clk_i) disable iff (!rst_ni)
    flush_done_o |-> pos_q == 0;
endproperty
assert_flush_done: assert property(flush_done_signal_p);

// CHK9: Error_Detection
property error_detection_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (EnProtection && err_o) |-> $past(pos_q) != pos_q;
endproperty
assert_error_detection: assert property(error_detection_p);

// CHK10: Storage_Overflow_Prevention
property storage_overflow_prevention_p;
    @(posedge clk_i) disable iff (!rst_ni)
    pos_q <= (InW + OutW);
endproperty
assert_storage_overflow: assert property(storage_overflow_prevention_p);

// CHK11: Data_Persistence
property data_persistence_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (!ready_i && valid_o) |=> stored_data == $past(stored_data);
endproperty
assert_data_persistence: assert property(data_persistence_p);

// CHK12: Reset_Behavior
property reset_behavior_p;
    @(posedge clk_i)
    !rst_ni |-> (!valid_o && !flush_done_o && !err_o && pos_q == 0);
endproperty
assert_reset_behavior: assert property(reset_behavior_p);

// CHK13: Partial_Write_Packing
property partial_write_packing_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (valid_ready_handshake_i && !(&mask_i)) |=> 
    stored_mask[InW-1:0] == $past(mask_i);
endproperty
assert_partial_write: assert property(partial_write_packing_p);

// CHK14: Back_to_Back_Transfers
property back_to_back_transfers_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (valid_ready_handshake_i && valid_ready_handshake_o) |=> ready_o;
endproperty
assert_back_to_back: assert property(back_to_back_transfers_p);

// CHK15: Stall_Handling
property stall_handling_p;
    @(posedge clk_i) disable iff (!rst_ni)
    (valid_o && !ready_i) |=> valid_o && (data_o == $past(data_o));
endproperty
assert_stall_handling: assert property(stall_handling_p);

// LLM

  // Property: Verify basic state retention behavior
  property state_retention_basic_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (pos_d == pos_q) |-> ##1 (pos_q == $past(pos_q));
  endproperty
  CHK1_state_retention_basic: assert property(state_retention_basic_p);

  // Property: Verify state transition stability
  property state_transition_stability_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (!flush_done) |-> (pos_d == pos_q);
  endproperty
  CHK2_state_transition_stability: assert property(state_transition_stability_p);

  // Property: Verify that in default case (when no other conditions are active), 
  // pos_d maintains the value of pos_q
  property default_state_hold_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (!flush_i && !ack_in && !ack_out) |-> (pos_d == pos_q);
  endproperty
  CHK1_default_state_hold: assert property(default_state_hold_p);

  // Property: Verify that pos_d never takes undefined values in default case
  property default_state_valid_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (!flush_i && !ack_in && !ack_out) |-> (!$isunknown(pos_d));
  endproperty
  CHK2_default_state_valid: assert property(default_state_valid_p);

  // Property: Verify that lod_idx is 0 when mask_i has no set bits
  property lod_idx_zero_mask_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (mask_i == '0) |-> (lod_idx == '0);
  endproperty
  CHK3_lod_idx_zero_mask: assert property(lod_idx_zero_mask_p);

  // Property: Verify that lod_idx always stays within valid bounds
  property lod_idx_bounds_p;
      @(posedge clk_i) disable iff (!rst_ni)
          1 |-> (lod_idx >= 0) && (lod_idx < InW);
  endproperty
  CHK4_lod_idx_bounds: assert property(lod_idx_bounds_p);

  // Property: Verify shiftr_data behavior when valid_i is low
  property shiftr_data_invalid_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (!valid_i) |-> (shiftr_data == '0);
  endproperty
  CHK5_shiftr_data_invalid: assert property(shiftr_data_invalid_p);

  // Property: Verify that lod_idx has exactly IdxW bits after casting
  property lod_idx_width_exact_p;
      @(posedge clk_i) disable iff (!rst_ni)
          1 |-> ($bits(lod_idx) == IdxW);
  endproperty
  CHK6_lod_idx_width_exact: assert property(lod_idx_width_exact_p);

  // Property: Verify that when mask_i has exactly one bit set, 
  // lod_idx matches the position of that bit
  property lod_idx_position_match_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ($onehot(mask_i)) |-> (mask_i[lod_idx] == 1'b1);
  endproperty
  CHK7_lod_idx_position_match: assert property(lod_idx_position_match_p);

  // Property: Verify that lod_idx maintains unsigned property
  // by never having its MSB used as sign bit
  property lod_idx_unsigned_value_p;
      @(posedge clk_i) disable iff (!rst_ni)
          1 |-> (lod_idx[IdxW-1] == 1'b0 || lod_idx == {IdxW{1'b1}});
  endproperty
  CHK8_lod_idx_unsigned_value: assert property(lod_idx_unsigned_value_p);

  // Property: Verify stored_data maintains its value when in hold state
  property stored_data_hold_value_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (({ack_in, ack_out} inside {2'b00, 2'b11}) && !flush_done) |=> 
          (stored_data == $past(stored_data));
  endproperty
  CHK9_stored_data_hold_value: assert property(stored_data_hold_value_p);

  // Property: Verify stored_data_next equals stored_data in hold state
  property stored_data_next_assignment_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ({ack_in, ack_out} inside {2'b00, 2'b11}) |-> 
          (stored_data_next == stored_data);
  endproperty
  CHK10_stored_data_next_assignment: assert property(stored_data_next_assignment_p);

  // Property: Verify stored_data is cleared on reset or flush
  property stored_data_clear_p;
      @(posedge clk_i) disable iff (0)
          (!rst_ni || flush_done) |=> (stored_data == '0);
  endproperty
  CHK11_stored_data_clear: assert property(stored_data_clear_p);

  // Property: Verify stored_data updates correctly from stored_data_next
  property stored_data_update_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (!flush_done) |=> (stored_data == $past(stored_data_next));
  endproperty
  CHK12_stored_data_update: assert property(stored_data_update_p);

  // Property: Verify stored_mask_next maintains stored_mask value in default case
  property stored_mask_next_retention_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ({ack_in, ack_out} == 2'b00) |-> (stored_mask_next == stored_mask);
  endproperty
  CHK13_stored_mask_next_retention: assert property(stored_mask_next_retention_p);

  // Property: Verify stored_mask properly updates from stored_mask_next
  property stored_mask_update_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (!flush_done) |=> (stored_mask == $past(stored_mask_next));
  endproperty
  CHK14_stored_mask_update: assert property(stored_mask_update_p);

  // Property: Verify stored_mask is cleared on reset
  property stored_mask_reset_p;
      @(posedge clk_i) disable iff (0)
          (!rst_ni) |=> (stored_mask == '0);
  endproperty
  CHK15_stored_mask_reset: assert property(stored_mask_reset_p);

  // Property: Verify flush state machine enters FlushIdle state after reset
  property flush_reset_state_p;
      @(posedge clk_i) disable iff (0)
          (!rst_ni) |=> (flush_st == FlushIdle);
  endproperty
  CHK16_flush_reset_state: assert property(flush_reset_state_p);

  // Property: Verify flush state machine stays in FlushIdle when no flush request  
  property flush_idle_stable_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ((flush_st == FlushIdle) && !flush_i) |=> (flush_st == FlushIdle);
  endproperty
  CHK17_flush_idle_stable: assert property(flush_idle_stable_p);

  // Property: Verify flush_valid is deasserted under specific conditions
  property flush_valid_deassert_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ((pos_q == '0 && flush_st == FlushSend) || 
           flush_st == FlushIdle) |-> 
          (flush_valid == 1'b0);
  endproperty
  CHK18_flush_valid_deassert: assert property(flush_valid_deassert_p);

  // Property: Verify relationship between flush_valid and valid_next
  property flush_valid_to_valid_next_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (int'(pos_q) < OutW) |-> 
          (valid_next == flush_valid);
  endproperty
  CHK19_flush_valid_to_valid_next: assert property(flush_valid_to_valid_next_p);

  // Property: Verify flush_valid remains stable in non-transitioning states
  property flush_valid_stable_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (flush_st == flush_st_next) |=> 
          (flush_valid == $past(flush_valid));
  endproperty
  CHK20_flush_valid_stable: assert property(flush_valid_stable_p);

  // Property: Verify flush_valid is deasserted after reset
  property flush_valid_reset_p;
      @(posedge clk_i) disable iff (0)
          (!rst_ni) |=> (flush_valid == 1'b0);
  endproperty
  CHK21_flush_valid_reset: assert property(flush_valid_reset_p);

  // Property: Verify flush_done is initially 0 when entering FlushSend state
  property flush_done_init_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (flush_st == FlushIdle && flush_st_next == FlushSend) |=> 
          (flush_done == 1'b0);
  endproperty
  CHK22_flush_done_init: assert property(flush_done_init_p);

  // Property: Verify flush_done remains 0 while pos_q is non-zero
  property flush_done_maintain_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ((flush_st == FlushSend) && (pos_q != '0)) |-> 
          (flush_done == 1'b0);
  endproperty
  CHK23_flush_done_maintain: assert property(flush_done_maintain_p);

  // Property: Verify flush_done becomes 1 only when pos_q is zero in FlushSend state
  property flush_done_completion_p;
      @(posedge clk_i) disable iff (!rst_ni)
          ((flush_st == FlushSend) && (pos_q == '0)) |-> 
          (flush_done == 1'b1);
  endproperty
  CHK24_flush_done_completion: assert property(flush_done_completion_p);

  // Property: Verify flush_done stability after completion until next flush operation
  property flush_done_stability_p;
      @(posedge clk_i) disable iff (!rst_ni)
          (flush_done && (flush_st != FlushSend)) |=> 
          (flush_done == $past(flush_done));
  endproperty
  CHK25_flush_done_stability: assert property(flush_done_stability_p);

  // Property: Verify flush_done is deasserted after reset
  property flush_done_reset_p;
      @(posedge clk_i) disable iff (0)
          (!rst_ni) |=> (flush_done == 1'b0);
  endproperty
  CHK26_flush_done_reset: assert property(flush_done_reset_p);

endmodule
