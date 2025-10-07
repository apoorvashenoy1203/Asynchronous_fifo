 `uvm_analysis_imp_decl(_w_cov)
`uvm_analysis_imp_decl(_r_cov)

class fifo_coverage extends uvm_subscriber #(fifo_seq_item);
  `uvm_component_utils(fifo_coverage)

  uvm_analysis_imp_w_cov #(fifo_seq_item, fifo_coverage) w_cov_port;
  uvm_analysis_imp_r_cov #(fifo_seq_item, fifo_coverage) r_cov_port;

  fifo_seq_item wseq;
  fifo_seq_item rseq;
  real w_cov, r_cov;

  covergroup write_c;
    w_inc: coverpoint wseq.winc;
    w_data: coverpoint wseq.wdata {
      bins w_low = {[0:63]};
      bins w_mid = {[64:127]};
      bins w_high = {[128:255]};
    }
    w_full: coverpoint wseq.wfull;
  endgroup

  covergroup read_c;
    r_inc: coverpoint rseq.rinc;

    r_data: coverpoint rseq.rdata {
      bins r_low = {[0:63]};
      bins r_mid = {[64:127]};
      bins r_high = {[128:255]};
    }
    r_empty: coverpoint rseq.rempty;
  endgroup

  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    write_c = new();
    read_c = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    w_cov_port = new("w_cov_port", this);
    r_cov_port = new("r_cov_port", this);
  endfunction

  function void write(fifo_seq_item t);
    // Not used in this subscriber
  endfunction

  function void write_w_cov(fifo_seq_item t);
    wseq = t;
    write_c.sample();
  endfunction

  function void write_r_cov(fifo_seq_item t);
    rseq = t;
    read_c.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    w_cov = write_c.get_coverage();
    r_cov = read_c.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
              $sformatf("WRITE Coverage: %0.2f%%", w_cov), UVM_MEDIUM)
    `uvm_info(get_type_name(),
              $sformatf("READ Coverage: %0.2f%%", r_cov), UVM_MEDIUM)
  endfunction
endclass

