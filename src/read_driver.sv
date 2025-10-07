   class read_driver extends uvm_driver #(fifo_seq_item);
  `uvm_component_utils(read_driver)

  virtual fifo_inf vif;
  fifo_seq_item read_seq;

  function new(string name = "read_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_inf)::get(this, "", "fifo_inf", vif))
      `uvm_fatal("NO_VIF", "Virtual interface failed in read_driver");
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if(!vif.rrst_n)begin
      vif.rinc<=1'b0;
      `uvm_info(get_type_name(),$sformatf("[%0t] DUT is in RESET=%0b !!!",$time,vif.rrst_n),UVM_LOW)
      @(posedge vif.rrst_n);
    end
   @(vif.rdrv_cb);
    forever begin

      seq_item_port.get_next_item(read_seq);
     drive();
      read_seq.rempty = vif.rempty;
      seq_item_port.item_done();
    end
  endtask
  task drive();
    vif.rinc<=read_seq.rinc;
    if(read_seq.rinc && !vif.rempty)begin
      `uvm_info(get_type_name(), $sformatf("Read: Rinc=%0b, rempty=%0b", read_seq.rinc, vif.rempty), UVM_MEDIUM)
    end else if(read_seq.rinc && vif.rempty) begin
      `uvm_info(get_type_name(), "Read attempted but FIFO is EMPTY", UVM_MEDIUM)
    end
          @(vif.rdrv_cb);
  endtask
endclass
