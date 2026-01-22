class fifo_driver extends uvm_driver #(fifo_transaction);

    `uvm_component_utils(fifo_driver)

    // Virtual interface handle
    virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_driver")
        end
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;

        // Objection handling
        phase.raise_objection(this);

        // Reset sequence
        vif.wr_cb.wr_rst_n <= 0;
        vif.rd_cb.rd_rst_n <= 0;
        vif.wr_cb.wr_en    <= 0;
        vif.rd_cb.rd_en    <= 0;
        vif.wr_cb.wr_data  <= '0;

        repeat (2) @(vif.wr_cb);
        repeat (2) @(vif.rd_cb);

        vif.wr_cb.wr_rst_n <= 1;
        vif.rd_cb.rd_rst_n <= 1;

        forever begin
            seq_item_port.get_next_item(tr);

            // WRITE operation
            if (tr.write_en) begin
                @(vif.wr_cb);
                if (!vif.wr_cb.full) begin
                    vif.wr_cb.wr_en   <= 1;
                    vif.wr_cb.wr_data <= tr.write_data;
                end
                @(vif.wr_cb);
                vif.wr_cb.wr_en <= 0;
            end

            // READ operation
            if (tr.read_en) begin
                @(vif.rd_cb);
                if (!vif.rd_cb.empty) begin
                    vif.rd_cb.rd_en <= 1;
                end
                @(vif.rd_cb);
                vif.rd_cb.rd_en <= 0;
            end

            seq_item_port.item_done();
        end

        phase.drop_objection(this);
    endtask

endclass
