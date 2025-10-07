  class write_driver extends uvm_driver #(fifo_seq_item);
  `uvm_component_utils(write_driver)

  fifo_seq_item write_seq;
  virtual fifo_inf vif;

  function new(string name = "write_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_inf)::get(this, "", "fifo_inf", vif))
      `uvm_fatal("NO_VIF", "Virtual interface failed in write_driver")
  endfunction

  virtual task run_phase(uvm_phase phase);

    super.run_phase(phase);
    if(!vif.wrst_n)begin
      vif.winc<=1'b0;
      `uvm_info(get_type_name(),$sformatf("[%0t] DUT is in RESET=%0b !!!",$time,vif.wrst_n),UVM_LOW)
      @(posedge vif.wrst_n);
    end
    forever begin
      seq_item_port.get_next_item(write_seq);
      drive();
      seq_item_port.item_done();
    end
  endtask
    task drive();
      vif.winc<=write_seq.winc;
      if(write_seq.winc && !vif.wfull) begin
      vif.wdata <= write_seq.wdata;
      `uvm_info(get_type_name(), $sformatf("Driver Writing: Data=0x%0h, wfull=%0b", write_seq.wdata, vif.wfull), UVM_MEDIUM)
    end
    else if(write_seq.winc && vif.wfull) begin
      `uvm_info(get_type_name(), "Write attempted but FIFO is FULL", UVM_MEDIUM)
    end
    else if(!write_seq.winc) begin
      `uvm_info(get_type_name(), "No Write Operation (winc=0)", UVM_MEDIUM)
    end
    @(vif.wrdrv_cb);
  endtask
endclass

