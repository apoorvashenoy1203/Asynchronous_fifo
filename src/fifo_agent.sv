`include "uvm_macros.svh"
import uvm_pkg::*;
class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent)

  write_driver wdrv;
  write_monitor wmon;
  write_sequencer wseqr;

  function new(string name = "write_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wdrv = write_driver::type_id::create("wdrv", this);
    wmon = write_monitor::type_id::create("wmon", this);
    wseqr = write_sequencer::type_id::create("wseqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wdrv.seq_item_port.connect(wseqr.seq_item_export);
  endfunction
endclass

class read_agent extends uvm_agent;
  `uvm_component_utils(read_agent)

  read_driver rdrv;
  read_monitor rmon;
  read_sequencer rseqr;

  function new(string name = "read_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rdrv = read_driver::type_id::create("rdrv", this);
    rmon = read_monitor::type_id::create("rmon", this);
    rseqr = read_sequencer::type_id::create("rseqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rdrv.seq_item_port.connect(rseqr.seq_item_export);
  endfunction
endclass
