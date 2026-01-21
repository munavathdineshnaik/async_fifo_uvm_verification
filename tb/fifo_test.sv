class fifo_test extends uvm_test;

    `uvm_component_utils(fifo_test)

    // Environment handle
    fifo_env env;

    // Virtual interface
    virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get virtual interface from top
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_test")
        end

        // Create environment
        env = fifo_env::type_id::create("env", this);

        // Pass interface down to environment
        uvm_config_db#(virtual fifo_if)::set(this, "env", "vif", vif);
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        fifo_base_sequence   base_seq;
        fifo_stress_sequence stress_seq;

        phase.raise_objection(this);

        // Run base sequence first
        base_seq = fifo_base_sequence::type_id::create("base_seq");
        base_seq.start(env.agent.sequencer);

        // Then run stress sequence
        stress_seq = fifo_stress_sequence::type_id::create("stress_seq");
        stress_seq.start(env.agent.sequencer);

        phase.drop_objection(this);
    endtask

endclass

