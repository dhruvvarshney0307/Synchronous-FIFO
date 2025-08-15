module sync_fifo_32x8 #(
  parameter DEPTH =32,
  parameter WIDTH = 8
) (
  input clk,rst,
  
  //write interface
  input wr_en,
  input wire [WIDTH-1:0] din,
  output full,
  
  //read
  input rd_en,
  output reg [WIDTH-1:0] dout,
  output empty
);
  
  reg [WIDTH-1:0] fifo [0:DEPTH-1];
  reg [$clog2(DEPTH):0] wr_ptr, rd_ptr;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      dout   <= 0;
    end
    else begin
      if (wr_en && !full) begin
        fifo[ wr_ptr[$clog2(DEPTH)-1:0] ] <= din;
        wr_ptr <= wr_ptr + 1;
      end

      if (rd_en && !empty) begin
        dout   <= fifo[ rd_ptr[$clog2(DEPTH)-1:0] ];
        rd_ptr <= rd_ptr + 1;
      end
    end
  end

  assign empty = (wr_ptr == rd_ptr);
  assign full  = ({ ~wr_ptr[$clog2(DEPTH)], wr_ptr[$clog2(DEPTH)-1:0] } == rd_ptr);

endmodule
