class fifo_stress_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_stress_sequence)

    // Number of transactions to generate
    rand int unsigned num_ops;

    constraint ops_range {
        num_ops inside {[50:200]};
    }

    function new(string name = "fifo_stress_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;

        // Randomize number of operations
        if (!randomize()) begin
            `uvm_fatal("SEQ", "Failed to randomize stress sequence")
        end

        repeat (num_ops) begin
            tr = fifo_transaction::type_id::create("tr");

            // Randomize transaction fields
            if (!tr.randomize()) begin
                `uvm_error("SEQ", "Transaction randomization failed")
            end

            start_item(tr);
            finish_item(tr);
        end
    endtask

endclass

