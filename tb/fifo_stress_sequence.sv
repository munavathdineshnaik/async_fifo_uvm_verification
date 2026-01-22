class fifo_stress_sequence extends uvm_sequence #(fifo_transaction);

    `uvm_object_utils(fifo_stress_sequence)

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
        assert(this.randomize());

        repeat (num_ops) begin
            tr = fifo_transaction::type_id::create("tr");

            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
        end
    endtask

endclass


