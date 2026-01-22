class fifo_test extends uvm_test;

    `uvm_component_utils(fifo_test)

    fifo_env env;
    virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_test")
        end

        // Set vif BEFORE creating env
        uvm_config_db#(virtual fifo_if)::set(this, "env", "vif", vif);

        env = fifo_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_base_sequence   base_seq;
        fifo_stress_sequence stress_seq;

        phase.raise_objection(this);

        base_seq = fifo_base_sequence::type_id::create("base_seq");
        base_seq.start(env.agent.sequencer);

        stress_seq = fifo_stress_sequence::type_id::create("stress_seq");
        stress_seq.start(env.agent.sequencer);

        phase.drop_objection(this);
    endtask

endclass
