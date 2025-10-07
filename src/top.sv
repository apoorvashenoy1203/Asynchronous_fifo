`include "uvm_macros.svh"
`include "design.sv"
`include "pkg.sv"
`include "fifo_interface.sv"
`include "defines.sv"
module top;
  import uvm_pkg::*;
  import pkg::*;
  bit wclk;
  bit rclk;
  bit wrst_n;
  bit rrst_n;

  initial wclk=1'b0;
   always #5 wclk = ~wclk;

  initial rclk=1'b0;
    always #10 rclk = ~rclk;
  initial begin
    wrst_n = 1'b0;
    rrst_n = 1'b0;

    #20 wrst_n = 1'b1;
    rrst_n = 1'b1;
    end


  fifo_inf vif(wclk, rclk, wrst_n, rrst_n);

  // DUT instantiation
  FIFO #(.DSIZE(`DATA_SIZE),.ASIZE(`ADDR_SIZE)) DUT (
    .wclk(wclk),
    .rclk(rclk),
    .wrst_n(wrst_n),
    .rrst_n(rrst_n),
    .winc(vif.winc),
    .rinc(vif.rinc),
    .wdata(vif.wdata),
    .rdata(vif.rdata),
    .wfull(vif.wfull),
    .rempty(vif.rempty)
  );

  // Clock generation
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  initial begin

    uvm_config_db#(virtual fifo_inf)::set(null, "*", "fifo_inf", vif);
    run_test("fifo_test");

  end
endmodule
