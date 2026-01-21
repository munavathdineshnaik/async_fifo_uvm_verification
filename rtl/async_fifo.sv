// Asynchronous FIFO

module async_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    // Write clock domain signals
    input  logic                  wr_clk,
    input  logic                  wr_rst_n,
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic                  full,

    // Read clock domain signals
    input  logic                  rd_clk,
    input  logic                  rd_rst_n,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  empty
);

    // FIFO depth from address width
    localparam int DEPTH = 1 << ADDR_WIDTH;

    // Storage array
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Binary pointers (extra MSB for wrap tracking)
    logic [ADDR_WIDTH:0] wr_ptr_bin, rd_ptr_bin;

    // Gray-codes of the pointers
    logic [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;

    // Synchronized pointers (Gray-codes)
    logic [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
    logic [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;

    
    // Binary to Gray conversion
    function automatic logic [ADDR_WIDTH:0] bin2gray(
        input logic [ADDR_WIDTH:0] bin
    );
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Write logic (write clock domain)
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_ptr_bin  <= '0;
            wr_ptr_gray <= '0;
        end
        else if (wr_en && !full) begin
            mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr_bin  <= wr_ptr_bin + 1'b1;
            wr_ptr_gray <= bin2gray(wr_ptr_bin + 1'b1);
        end
    end

    // Read logic (read clock domain)
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rd_ptr_bin  <= '0;
            rd_ptr_gray <= '0;
            rd_data     <= '0;
        end
        else if (rd_en && !empty) begin
            rd_data     <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
            rd_ptr_bin  <= rd_ptr_bin + 1'b1;
            rd_ptr_gray <= bin2gray(rd_ptr_bin + 1'b1);
        end
    end

    // Pointer synchronization (CDC)
    // Read pointer synchronized into write clock domain
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_ptr_gray_sync1 <= '0;
            rd_ptr_gray_sync2 <= '0;
        end
        else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // Write pointer synchronized into read clock domain
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_ptr_gray_sync1 <= '0;
            wr_ptr_gray_sync2 <= '0;
        end
        else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // FIFO status generation
    // Empty when read pointer catches up to write pointer
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

    // Full when write pointer is one lap ahead of read pointer
    assign full  = (wr_ptr_gray ==
                   {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                     rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});

endmodule

