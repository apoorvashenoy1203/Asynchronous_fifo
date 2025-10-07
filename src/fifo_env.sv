  class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  write_agent wagt;
  read_agent ragt;
  vsequencer vseqr;
  fifo_scoreboard scb;
  fifo_coverage cov;

  function new(string name = "fifo_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wagt = write_agent::type_id::create("wagt", this);
    ragt = read_agent::type_id::create("ragt", this);
    vseqr = vsequencer::type_id::create("vseqr", this);
    scb = fifo_scoreboard::type_id::create("scb", this);
    cov = fifo_coverage::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.wseqr = wagt.wseqr;
    vseqr.rseqr = ragt.rseqr;
    wagt.wmon.mon_ab.connect(scb.write_export);
    wagt.wmon.mon_ab.connect(cov.w_cov_port);
    ragt.rmon.mon_ap.connect(scb.read_export);
    ragt.rmon.mon_ap.connect(cov.r_cov_port);
  endfunction
endclass
