class fifo_monitor extends uvm_monitor;

    `uvm_component_utils(fifo_monitor)

    // Virtual interface
    virtual fifo_if vif;

    // Analysis port
    uvm_analysis_port #(fifo_transaction) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_monitor")
        end
    endfunction

    task run_phase(uvm_phase phase);
        fork
            monitor_write();
            monitor_read();
        join
    endtask

    // Write-domain monitor
    task monitor_write();
        fifo_transaction tr;
        forever begin
            @(vif.wr_cb);
            if (vif.wr_cb.wr_en && !vif.wr_cb.full) begin
                tr = fifo_transaction::type_id::create("tr");
                tr.write_en   = 1;
                tr.read_en    = 0;
                tr.write_data = vif.wr_cb.wr_data;
                analysis_port.write(tr);
            end
        end
    endtask

    // Read-domain monitor
    task monitor_read();
        fifo_transaction tr;
        forever begin
            @(vif.rd_cb);
            if (vif.rd_cb.rd_en && !vif.rd_cb.empty) begin
                tr = fifo_transaction::type_id::create("tr");
                tr.write_en  = 0;
                tr.read_en   = 1;
                tr.read_data = vif.rd_cb.rd_data;
                analysis_port.write(tr);
            end
        end
    endtask

endclass
