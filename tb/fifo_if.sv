interface fifo_if #(
    parameter int DATA_WIDTH = 8
)(
    input logic wr_clk,
    input logic rd_clk
);

    // Write domain signals
    logic                  wr_rst_n;
    logic                  wr_en;
    logic [DATA_WIDTH-1:0] wr_data;
    logic                  full;

    // Read domain signals
    logic                  rd_rst_n;
    logic                  rd_en;
    logic [DATA_WIDTH-1:0] rd_data;
    logic                  empty;

    // Clocking blocks

    // Write clocking block
    clocking wr_cb @(posedge wr_clk);
        output wr_en;
        output wr_data;
        input  full;
    endclocking

    // Read clocking block
    clocking rd_cb @(posedge rd_clk);
        output rd_en;
        input  rd_data;
        input  empty;
    endclocking

endinterface

