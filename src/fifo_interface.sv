interface fifo_inf(input bit wclk, input bit rclk, input bit wrst_n, input bit rrst_n);

  logic winc;
  logic [`DATA_SIZE-1:0] wdata;
  bit wfull;
  logic rinc;
  logic [`DATA_SIZE-1:0] rdata;
  bit rempty;
  logic[`ADDR_SIZE:0]wptr;
  logic[`ADDR_SIZE:0]rptr;

  clocking wrdrv_cb @(posedge wclk);
    output  wrst_n,winc, wdata;
    input wfull;
  endclocking

  clocking wmon_cb @(posedge wclk);
    input wfull, wptr,wrst_n, winc, wdata;
  endclocking

  clocking rdrv_cb @(posedge rclk);
    output  rrst_n,rinc;
    input rempty;
  endclocking

  clocking rmon_cb @(posedge rclk);
    input  rrst_n,rptr, rinc, rdata, rempty;

  endclocking
  property p2;
    @(posedge wclk) disable iff(!wrst_n)
      (winc && wfull) |-> $stable(wdata);
  endproperty
  assert property(p2)
    else $error("p2 FAILED: Data changed during write when FULL!");

  property p3;
    @(posedge rclk) disable iff(!rrst_n)
      rinc |-> !rempty;
  endproperty
  assert property(p3)
    else $error("p3 FAILED: Read attempted when FIFO is EMPTY!");

  property p4;
    @(posedge rclk) disable iff(!rrst_n)
      (rinc && !rempty) |-> !$isunknown(rdata);
  endproperty
  assert property(p4)
    else $error("p4 FAILED: rdata is X/Z on valid read!");

  property p5;
    @(posedge wclk) disable iff(!wrst_n)
      !(wfull && rempty);
  endproperty
  assert property(p5)
    else $error("p5 FAILED: FIFO signaled FULL and EMPTY simultaneously!");
endinterface
