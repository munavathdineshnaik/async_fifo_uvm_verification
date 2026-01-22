`timescale 1ns/1ps

module tb_async_fifo;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;

    logic wr_clk;
    logic rd_clk;

    fifo_if #(DATA_WIDTH) fifo_if_inst (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk)
    );

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .wr_clk   (wr_clk),
        .wr_rst_n (fifo_if_inst.wr_rst_n),
        .wr_en    (fifo_if_inst.wr_en),
        .wr_data  (fifo_if_inst.wr_data),
        .full     (fifo_if_inst.full),
        .rd_clk   (rd_clk),
        .rd_rst_n (fifo_if_inst.rd_rst_n),
        .rd_en    (fifo_if_inst.rd_en),
        .rd_data  (fifo_if_inst.rd_data),
        .empty    (fifo_if_inst.empty)
    );

    // Clocks
    initial wr_clk = 0;
    always #5 wr_clk = ~wr_clk;

    initial rd_clk = 0;
    always #7 rd_clk = ~rd_clk;

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

    // Simple write
    initial begin
        wait(fifo_if_inst.wr_rst_n);
        repeat (8) begin
            @(posedge wr_clk);
            if (!fifo_if_inst.full) begin
                fifo_if_inst.wr_en   <= 1;
                fifo_if_inst.wr_data <= $random;
            end
        end
        fifo_if_inst.wr_en <= 0;
    end

    // Simple read
    initial begin
        wait(fifo_if_inst.rd_rst_n);
        #80;
        repeat (8) begin
            @(posedge rd_clk);
            if (!fifo_if_inst.empty)
                fifo_if_inst.rd_en <= 1;
        end
        fifo_if_inst.rd_en <= 0;
    end

    initial #500 $finish;

endmodule
