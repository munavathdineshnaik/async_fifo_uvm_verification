class fifo_agent extends uvm_agent;

    `uvm_component_utils(fifo_agent)

    // Agent components
    fifo_driver     driver;
    fifo_sequencer  sequencer;
    fifo_monitor    monitor;

    // Virtual interface
    virtual fifo_if vif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get virtual interface
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_agent")
        end

        // creating monitor
        monitor = fifo_monitor::type_id::create("monitor", this);
        uvm_config_db#(virtual fifo_if)::set(this, "monitor", "vif", vif);

        // Created driver & sequencer only if active
        if (is_active == UVM_ACTIVE) begin
            driver    = fifo_driver::type_id::create("driver", this);
            sequencer = fifo_sequencer::type_id::create("sequencer", this);

            uvm_config_db#(virtual fifo_if)::set(this, "driver", "vif", vif);
        end
    endfunction

    // Connecting phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass

