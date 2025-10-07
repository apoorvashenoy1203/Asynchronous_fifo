 class write_monitor extends uvm_monitor;
  `uvm_component_utils(write_monitor)

  virtual fifo_inf vif;
  uvm_analysis_port #(fifo_seq_item) mon_ab;

  function new(string name = "write_monitor", uvm_component parent = null);
    super.new(name, parent);
    mon_ab = new("mon_ab", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_inf)::get(this, "", "fifo_inf", vif))
      `uvm_fatal("NO_VIF", "No virtual interface in write_monitor");
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_seq_item tr;
    @(posedge vif.wrst_n);

    forever begin
  @(vif.wmon_cb);

  if (vif.wmon_cb.winc) begin
    tr = fifo_seq_item::type_id::create("tr");
    tr.wrst_n = vif.wmon_cb.wrst_n;
    tr.winc = vif.wmon_cb.winc;
    tr.wdata = vif.wmon_cb.wdata;
    tr.wfull = vif.wmon_cb.wfull;
    `uvm_info("WMON", $sformatf("WRITE MON:  wrst_n=%0b winc=%0b wdata=0x%0h wfull=%0b",
               tr.wrst_n,tr.winc, tr.wdata, tr.wfull), UVM_LOW)
    mon_ab.write(tr);
  end
end
  endtask
endclass
