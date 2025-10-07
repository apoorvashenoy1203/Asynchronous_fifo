  class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_env env;
  fifo_base_sequence seq;

  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = fifo_base_sequence::type_id::create("seq");
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass



class write_normal_test extends fifo_test;
  `uvm_component_utils(write_normal_test)

  write_normal_sequence wseq;

  function new(string name = "write_normal_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wseq = write_normal_sequence::type_id::create("wseq");
    wseq.start(env.wagt.wseqr);
    phase.drop_objection(this);
  endtask
endclass

class write extends fifo_test;
  `uvm_component_utils(write)

  write wseq;

  function new(string name = "write", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wseq = write::type_id::create("wseq");
    wseq.start(env.wagt.wseqr);
    phase.drop_objection(this);
  endtask
endclass

class read_normal_test extends fifo_test;
  `uvm_component_utils(read_normal_test)

  read_normal_sequence rseq;

  function new(string name = "read_normal_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rseq = read_normal_sequence::type_id::create("rseq");
    rseq.start(env.ragt.rseqr);
    phase.drop_objection(this);
  endtask
endclass

class read extends fifo_test;
  `uvm_component_utils(read)

  read rseq;

  function new(string name = "read", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rseq = read::type_id::create("rseq");
    rseq.start(env.ragt.rseqr);
    phase.drop_objection(this);
  endtask
endclass


///////////////////////////////

class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_vsequence vseq;
  fifo_env env;

  function new(string name = "fifo_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    vseq = fifo_vsequence::type_id::create("vseq");
    vseq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
