`timescale 1ns/1ps

`include "fifo_if.sv"
`include "fifo_assertions.sv"
`include "fifo_test.sv"

module tb_top;

    // Parameters
    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;

    // Clocks
    logic wr_clk;
    logic rd_clk;

    // Clock generation
    initial wr_clk = 0;
    always #5 wr_clk = ~wr_clk;   // 100 MHz

    initial rd_clk = 0;
    always #7 rd_clk = ~rd_clk;   // ~71 MHz (asynchronous)

    // Interface instance
    fifo_if #(DATA_WIDTH) fifo_if_inst (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk)
    );

    // DUT instance
    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        // Write domain
        .wr_clk   (wr_clk),
        .wr_rst_n (fifo_if_inst.wr_rst_n),
        .wr_en    (fifo_if_inst.wr_en),
        .wr_data  (fifo_if_inst.wr_data),
        .full     (fifo_if_inst.full),

        // Read domain
        .rd_clk   (rd_clk),
        .rd_rst_n (fifo_if_inst.rd_rst_n),
        .rd_en    (fifo_if_inst.rd_en),
        .rd_data  (fifo_if_inst.rd_data),
        .empty    (fifo_if_inst.empty)
    );

    // UVM configuration & start
    initial begin
        // Make interface available to UVM
        uvm_config_db#(virtual fifo_if)::set(
            null, "*", "vif", fifo_if_inst
        );

        // Start UVM test
        run_test("fifo_test");
    end

endmodule

