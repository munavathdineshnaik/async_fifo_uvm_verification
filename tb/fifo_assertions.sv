module fifo_assertions (fifo_if vif);

  // No write allowed when FIFO is FULL
  property no_write_when_full;
    @(posedge vif.wr_clk)
      disable iff (!vif.wr_rst_n)
      !(vif.wr_en && vif.full);
  endproperty

  assert_no_write_when_full: assert property (no_write_when_full)
    else $error("ASSERTION FAILED: Write when FIFO is FULL");

  // No read allowed when FIFO is EMPTY
  property no_read_when_empty;
    @(posedge vif.rd_clk)
      disable iff (!vif.rd_rst_n)
      !(vif.rd_en && vif.empty);
  endproperty

  assert_no_read_when_empty: assert property (no_read_when_empty)
    else $error("ASSERTION FAILED: Read when FIFO is EMPTY");

endmodule

