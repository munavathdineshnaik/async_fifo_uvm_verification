class fifo_scoreboard extends uvm_component;

    `uvm_component_utils(fifo_scoreboard)

    // Analysis import
    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) analysis_imp;

    // Reference model queue (parameterized width)
    bit [DATA_WIDTH-1:0] exp_queue[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    // Receive transactions from monitor
    function void write(fifo_transaction tr);

        // WRITE observed
        if (tr.write_en) begin
            exp_queue.push_back(tr.write_data);
            `uvm_info("SCOREBOARD",
                      $sformatf("WRITE: 0x%0h (depth=%0d)",
                                tr.write_data, exp_queue.size()),
                      UVM_LOW)
        end

        // READ observed
        if (tr.read_en) begin
            if (exp_queue.size() == 0) begin
                `uvm_error("SCOREBOARD",
                           "READ seen but reference queue empty")
            end
            else begin
                bit [DATA_WIDTH-1:0] exp_data;
                exp_data = exp_queue.pop_front();

                if (tr.read_data !== exp_data) begin
                    `uvm_error("SCOREBOARD",
                               $sformatf("MISMATCH exp=0x%0h act=0x%0h",
                                         exp_data, tr.read_data))
                end
                else begin
                    `uvm_info("SCOREBOARD",
                              $sformatf("READ MATCH: 0x%0h", tr.read_data),
                              UVM_LOW)
                end
            end
        end

    endfunction

endclass
