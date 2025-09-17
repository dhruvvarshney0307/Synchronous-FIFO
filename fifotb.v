module tb;
  parameter DEPTH =32;
  parameter WIDTH = 8;
  
  
  reg clk,rst;
  reg wr_en;
  reg [WIDTH-1:0] din;
  wire full;
  
  //read
  reg rd_en;
  wire [WIDTH-1:0] dout;
  wire empty;
  
  sync_fifo_32x8 uut(
    clk,rst,wr_en,din,full,rd_en,dout,empty);
  
 initial begin 
   clk = 0;
 end
 
  always #5 clk=~clk;
  
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end
  
  
initial begin
 rst = 1;
 wr_en=0;
 rd_en=0;
 din=0;
 


repeat(2)@(posedge clk);
rst=0;
#10;

$display("\n===== sync_fifo  Tests Start =====\n");
  // 1) Write Test and check if empty went low
tc_write();

// 2) Read Test
tc_read();

  //3)Full test
  tc_full();
  //4)Empty test
 tc_empty();
  
  tc_wraparound();
 tc_simultaneous_read_write();
 tc_overflow();
 tc_underflow();
  tc_reset();

  
#10;
$finish;
  
end

  task tc_write();
    begin
    $display("Write operation test");
    din = 8'd124;
    @(posedge clk)
    wr_en=1;
    @(posedge clk);
      wr_en = 0;
    
      if(!empty)
      $display("PASS: FIFO  not empty after write.");
    else
      $display("Fail: FIFO  empty after write.");
    end
  endtask
  
  task tc_read();
    begin
    $display("Read operation test");
    
  @(posedge clk)
    rd_en=1;
    @(posedge clk);
      rd_en = 0;
    
    if(dout==8'd124)
      $display("PASS: Read data = 124 as expected.");
    else
      $display("ERROR: Read data = 0x%0d (expected 124).", dout);
    end
  endtask
  
  
task tc_full();
  
  integer i;
  begin
  $display("Full Condition test");
  for (i = 0; i < DEPTH; i = i + 1) begin
  @(posedge clk)
  wr_en  = 1;
  din=$random; 
  @(posedge clk)
  wr_en =0;
end
  
  if(full)
    $display("PASS: full flag asserted after %0d writes.", DEPTH);
  else
    $display("ERROR: full flag = 0 (expected 1) after writing %0d items.", DEPTH);
  end
endtask

  task tc_empty();
    begin
      while(!empty) begin
        @(posedge clk);
        rd_en = 1; end
      @(posedge clk)
      rd_en=0;
      if (!empty) $display("Error: FIFO empty flag not set.");
  else $display("FIFO empty flag set correctly");
end 
  endtask
  
k

  //------------

endmodule
