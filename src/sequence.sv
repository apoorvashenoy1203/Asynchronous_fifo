  class fifo_base_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_base_sequence)

  function new(string name = "fifo_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    fifo_seq_item req;
    req = fifo_seq_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
  endtask
endclass


class write_normal_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(write_normal_sequence)

  function new(string name = "write_normal_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10)begin
    fifo_seq_item req;
      `uvm_do_with(req, { req.winc == 1;})

    end

      endtask
endclass

class write extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(write)

  function new(string name = "write");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10)begin
    fifo_seq_item req;
      `uvm_do_with(req, { req.winc==0;})

    end

      endtask
endclass





class read_normal_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(read_normal_sequence)

  function new(string name = "read_normal_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10)begin
    fifo_seq_item req;
      `uvm_do_with(req, { req.rinc == 1;})
    end
  endtask
endclass

class read extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(read)

  function new(string name = "read");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10)begin
    fifo_seq_item req;
      `uvm_do_with(req, { req.rinc inside{0,1};})
    end
  endtask
endclass

class fifo_vsequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_vsequence)

  write_normal_sequence wr_seq1;
  write wr_seq2;
  read_normal_sequence  rd_seq1;
  read rd_seq2;

  `uvm_declare_p_sequencer(vsequencer)

  function new(string name = "fifo_vsequence");
    super.new(name);
  endfunction

  virtual task body();
    // Create sequence objects
    wr_seq1 = write_normal_sequence::type_id::create("wr_seq1");
    wr_seq2 = write::type_id::create("wr_seq2");
    rd_seq1 = read_normal_sequence::type_id::create("rd_seq1");
    rd_seq2 = read::type_id::create("rd_seq2");

    fork
      begin
        $display("write");
        wr_seq1.start(p_sequencer.wseqr);
        wr_seq2.start(p_sequencer.wseqr);

      end
      begin
        $display("read");

        rd_seq1.start(p_sequencer.rseqr);
        rd_seq2.start(p_sequencer.rseqr);

      end
    join
  endtask

endclass
