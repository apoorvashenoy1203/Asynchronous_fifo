 module FIFO_memory #(parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4)(
    output [DATA_SIZE-1:0] rdata,        // Output data - data to be read
    input [DATA_SIZE-1:0] wdata,         // Input data - data to be written
    input [ADDR_SIZE-1:0] waddr, raddr,  // Write and read address
    input wclk_en, wfull, wclk          // Write clock enable, write full, write clock
    );

    localparam DEPTH = 1<<ADDR_SIZE;     // Depth of the FIFO memory
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];// Memory array

    assign rdata = mem[raddr];// Read data

  always@(*)begin
    $display("[%0t] rdata[%0d]=%0d",$time,raddr,rdata);
  end

  always @(posedge wclk)begin
    if (wclk_en && !wfull)begin
      mem[waddr] <= wdata; // Write data
      $display("[%0t] wdata[%0d]=%0d",$time,waddr,wdata);
    end
  end
 endmodule
