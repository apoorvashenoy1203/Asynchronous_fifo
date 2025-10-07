 class read_monitor extends uvm_monitor;
  `uvm_component_utils(read_monitor)

  virtual fifo_inf vif;
  uvm_analysis_port #(fifo_seq_item) mon_ap;

  function new(string name = "read_monitor", uvm_component parent = null);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_inf)::get(this, "", "fifo_inf", vif))
      `uvm_fatal("NO_VIF", "No virtual interface in read_monitor");
  endfunction

  task run_phase(uvm_phase phase);
    fifo_seq_item tr;
    @(posedge vif.rrst_n);

    forever begin
  @(vif.rmon_cb);

      if (vif.rmon_cb.rinc) begin
    tr = fifo_seq_item::type_id::create("tr");
    tr.rrst_n = vif.rmon_cb.rrst_n;
    tr.rinc = vif.rmon_cb.rinc;
    tr.rdata = vif.rmon_cb.rdata;
    tr.rempty = vif.rmon_cb.rempty;
    `uvm_info("RMON", $sformatf("READ MON: rrst_n=%0b, rinc=%0b rdata=0x%0h rempty=%0b",
               tr.rrst_n,tr.rinc, tr.rdata, tr.rempty), UVM_LOW)
    mon_ap.write(tr);
  end
end
  endtask
endclass
