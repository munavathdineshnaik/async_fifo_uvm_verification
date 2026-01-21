class fifo_transaction extends uvm_sequence_item;

    // Control fields
    rand bit write_en;
    rand bit read_en;

    // Data associated with write operations
    rand bit [7:0] write_data;

    // Observed read data 
    bit  [7:0] read_data;

    // Constraints

    // Do not allow read and write to be asserted together
    constraint rw_exclusive {
        !(write_en && read_en);
    }

    // If read is enabled, write must be disabled
    constraint valid_ops {
        write_en != read_en;
    }

    // UVM automation
    `uvm_object_utils_begin(fifo_transaction)
        `uvm_field_int(write_en , UVM_DEFAULT)
        `uvm_field_int(read_en  , UVM_DEFAULT)
        `uvm_field_int(write_data, UVM_DEFAULT)
        `uvm_field_int(read_data , UVM_DEFAULT | UVM_NOPACK)
    `uvm_object_utils_end

    // Constructor

    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction

endclass

