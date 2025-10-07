`uvm_analysis_imp_decl(_write)
 `uvm_analysis_imp_decl(_read)

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  logic [`DATA_SIZE-1:0] scb_q[$];       // Scoreboard queue
  logic [`DATA_SIZE-1:0] expected_data;  // Expected data for comparison
  int match_count = 0;
  int mismatch_count = 0;
  int pass_count = 0;
  int fail_count = 0;

 uvm_analysis_imp_write #(fifo_seq_item, fifo_scoreboard) write_export;
 uvm_analysis_imp_read  #(fifo_seq_item, fifo_scoreboard) read_export;

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    write_export = new("write_export", this);
    read_export  = new("read_export", this);
  endfunction

  // Write-side callback
  function void write_write(fifo_seq_item t);
    if (!t.wrst_n) begin
      `uvm_info(get_type_name(), "RESET ACTIVE during write", UVM_LOW)
      // Compare expected write values during reset
      if (t.wfull == 0) begin
        `uvm_info(get_type_name(), $sformatf("Write Reset TEST PASSED @ %0t", $time), UVM_LOW)
        pass_count++;
      end else begin
        `uvm_error(get_type_name(), $sformatf("Write Reset TEST FAILED @ %0t", $time))
        fail_count++;
      end
      return;
    end

    if (t.winc) begin
      if (!t.wfull) begin
        scb_q.push_back(t.wdata);
        `uvm_info(get_type_name(),
          $sformatf("WRITE @%0t -> PUSHED: %0d (Queue size=%0d)",
                    $time, t.wdata, scb_q.size()), UVM_MEDIUM)
      end else begin
        `uvm_info(get_type_name(),
          $sformatf("FULL @%0t -> Write attempt ignored (data=%0d)",
                    $time, t.wdata), UVM_MEDIUM)
      end
    end
  endfunction

  // Read-side callback
  function void write_read(fifo_seq_item t);

    if (!t.rrst_n) begin
      `uvm_info(get_type_name(), "RESET ACTIVE during read", UVM_LOW)
      // Compare expected read values during reset
      if (t.rempty && t.rdata == 0) begin
        `uvm_info(get_type_name(), $sformatf("Read Reset TEST PASSED @ %0t", $time), UVM_LOW)
        pass_count++;
      end else begin
        `uvm_error(get_type_name(), $sformatf("Read Reset TEST FAILED @ %0t", $time))
        fail_count++;
      end
      return;
    end

    if (t.rinc) begin
      // ----------- Protocol Checks -----------
      if (t.rempty && scb_q.size() == 0) begin
        `uvm_info(get_type_name(),
          $sformatf("EMPTY @%0t: DUT correctly reported EMPTY.", $time),
          UVM_MEDIUM)
        return;
      end

      if (t.rempty && scb_q.size() != 0) begin
        `uvm_error(get_type_name(),
          "DUT PROTOCOL ERROR: rempty=1 but scoreboard queue not empty!")
        return;
      end else if (!t.rempty && scb_q.size() == 0) begin
        `uvm_error(get_type_name(),
          "DUT PROTOCOL ERROR: rempty=0 but scoreboard queue empty!")
        return;
      end

      // ----------- Data Comparison -----------
      if (!t.rempty && scb_q.size() > 0) begin
        expected_data = scb_q.pop_front();
        if (t.rdata === expected_data) begin
          match_count++;
          pass_count++;
          $display("==============MATCH===============");
          `uvm_info(get_type_name(),
            $sformatf("MATCH @%0t -> expected=%0d, received=%0d (Queue size=%0d)",
                      $time, expected_data, t.rdata, scb_q.size()), UVM_MEDIUM)
        end else begin
          mismatch_count++;
          fail_count++;
          $display("==============MISMATCH===============");
          `uvm_error(get_type_name(),
            $sformatf("MISMATCH @%0t -> expected=%0d, received=%0d",
                      $time, expected_data, t.rdata))
        end
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("SCOREBOARD SUMMARY: MATCH=%0d | MISMATCH=%0d | PASS=%0d | FAIL=%0d",
                match_count, mismatch_count, pass_count, fail_count),
      UVM_LOW)
  endfunction

endclass
