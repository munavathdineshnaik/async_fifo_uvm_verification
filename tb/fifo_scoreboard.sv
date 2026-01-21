class fifo_scoreboard extends uvm_component;

    `uvm_component_utils(fifo_scoreboard)

    // Analysis import to receive transactions from monitor
    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) analysis_imp;

    bit [7:0] exp_queue[$];

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    // Analysis write method
    function void write(fifo_transaction tr);

        // WRITE transaction observed
        if (tr.write_en) begin
            exp_queue.push_back(tr.write_data);
            `uvm_info("SCOREBOARD",
                      $sformatf("WRITE observed: 0x%0h (queue depth=%0d)",
                                tr.write_data, exp_queue.size()),
                      UVM_LOW)
        end

        // READ transaction observed
        if (tr.read_en) begin
            if (exp_queue.size() == 0) begin
                `uvm_error("SCOREBOARD",
                           "READ observed but reference queue is empty")
            end
            else begin
                bit [7:0] exp_data;
                exp_data = exp_queue.pop_front();

                if (tr.read_data !== exp_data) begin
                    `uvm_error("SCOREBOARD",
                               $sformatf("DATA MISMATCH: expected=0x%0h actual=0x%0h",
                                         exp_data, tr.read_data))
                end
                else begin
                    `uvm_info("SCOREBOARD",
                              $sformatf("READ match: 0x%0h", tr.read_data),
                              UVM_LOW)
                end
            end
        end

    endfunction

endclass

