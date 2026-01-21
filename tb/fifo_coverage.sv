class fifo_coverage extends uvm_component;

    `uvm_component_utils(fifo_coverage)

    // Analysis import to receive observed transactions
    uvm_analysis_imp #(fifo_transaction, fifo_coverage) analysis_imp;

    // Coverage variables
    bit write_seen;
    bit read_seen;
    bit [7:0] data_val;

    // Covergroup definition
    covergroup fifo_cg;

        // Write operation coverage
        write_cp : coverpoint write_seen {
            bins write = {1};
        }

        // Read operation coverage
        read_cp : coverpoint read_seen {
            bins read = {1};
        }

        // Data value coverage (basic)
        data_cp : coverpoint data_val {
            bins low  = {[8'h00:8'h3F]};
            bins mid  = {[8'h40:8'h7F]};
            bins high = {[8'h80:8'hFF]};
        }

        // Cross coverage
        wr_rd_cross : cross write_cp, read_cp;

    endgroup

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
        fifo_cg = new();
    endfunction

    // Analysis write method
    function void write(fifo_transaction tr);

        // Reset observation flags
        write_seen = 0;
        read_seen  = 0;

        if (tr.write_en) begin
            write_seen = 1;
            data_val   = tr.write_data;
        end

        if (tr.read_en) begin
            read_seen = 1;
        end

        // Sample coverage
        fifo_cg.sample();

    endfunction

endclass

