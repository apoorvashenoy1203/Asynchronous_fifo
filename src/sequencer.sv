  class write_sequencer extends uvm_sequencer #(fifo_seq_item);
  `uvm_component_utils(write_sequencer)

  function new(string name = "write_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

class read_sequencer extends uvm_sequencer #(fifo_seq_item);
  `uvm_component_utils(read_sequencer)

  function new(string name = "read_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

class vsequencer extends uvm_sequencer;
  write_sequencer wseqr;
  read_sequencer rseqr;

  `uvm_component_utils(vsequencer)

  function new(string name = "vsequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
