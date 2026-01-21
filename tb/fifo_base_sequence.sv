class fifo_base_sequence extends uvm_sequence #(fifo_transaction);
   `uvm_object_utils(fifo_base_sequence)

    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction tr;

        // Write phase
        repeat (8) begin
            tr = fifo_transaction::type_id::create("tr");
            tr.write_en   = 1;
            tr.read_en    = 0;
            tr.write_data = $random;
            start_item(tr);
            finish_item(tr);
        end

        // Read phase
        repeat (8) begin
            tr = fifo_transaction::type_id::create("tr");
            tr.write_en = 0;
            tr.read_en  = 1;
            start_item(tr);
            finish_item(tr);
        end
    endtask

endclass

