`timescale 1ns/1ps

module tb_async_fifo;

    // Parameters
    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;

    // Clocks
    logic wr_clk;
    logic rd_clk;

    // Interface
    fifo_if #(DATA_WIDTH) fifo_if_inst (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk)
    );

    // DUT
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

    // Clock generation
    initial wr_clk = 0;
    always #5  wr_clk = ~wr_clk;   // 100 MHz

    initial rd_clk = 0;
    always #7  rd_clk = ~rd_clk;   // ~71 MHz (async)

    // Reset
    initial begin
        fifo_if_inst.wr_rst_n = 0;
        fifo_if_inst.rd_rst_n = 0;
        fifo_if_inst.wr_en    = 0;
        fifo_if_inst.rd_en    = 0;
        fifo_if_inst.wr_data  = '0;

        #50;
        fifo_if_inst.wr_rst_n = 1;
        fifo_if_inst.rd_rst_n = 1;
    end

    // Write Input
    initial begin
        wait(fifo_if_inst.wr_rst_n);
        repeat (10) begin
            @(fifo_if_inst.wr_cb);
            if (!fifo_if_inst.full) begin
                fifo_if_inst.wr_cb.wr_en   <= 1;
                fifo_if_inst.wr_cb.wr_data <= $random;
            end
        end
        @(fifo_if_inst.wr_cb);
        fifo_if_inst.wr_cb.wr_en <= 0;
    end

    // Read Input
    initial begin
        wait(fifo_if_inst.rd_rst_n);
        #80; 
        repeat (10) begin
            @(fifo_if_inst.rd_cb);
            if (!fifo_if_inst.empty) begin
                fifo_if_inst.rd_cb.rd_en <= 1;
            end
        end
        @(fifo_if_inst.rd_cb);
        fifo_if_inst.rd_cb.rd_en <= 0;
    end

    // End 
    initial begin
        #500;
        $finish;
    end

endmodule

