class fifo_coverage extends uvm_component;

    `uvm_component_utils(fifo_coverage)

    uvm_analysis_imp #(fifo_transaction, fifo_coverage) analysis_imp;

    bit write_seen;
    bit read_seen;
    bit [DATA_WIDTH-1:0] data_val;

    covergroup fifo_cg;

        write_cp : coverpoint write_seen {
            bins write = {1};
        }

        read_cp : coverpoint read_seen {
            bins read = {1};
        }

        data_cp : coverpoint data_val {
            bins low  = {[0            : DATA_WIDTH'(2**(DATA_WIDTH-2)-1)]};
            bins mid  = {[DATA_WIDTH'(2**(DATA_WIDTH-2)) :
                          DATA_WIDTH'(2**(DATA_WIDTH-1)-1)]};
            bins high = {[DATA_WIDTH'(2**(DATA_WIDTH-1)) :
                          DATA_WIDTH'(2**DATA_WIDTH-1)]};
        }

    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
        fifo_cg = new();
    endfunction

    function void write(fifo_transaction tr);

        write_seen = tr.write_en;
        read_seen  = tr.read_en;

        if (tr.write_en) begin
            data_val = tr.write_data;
        end

        fifo_cg.sample();

    endfunction

endclass : fifo_coverage
