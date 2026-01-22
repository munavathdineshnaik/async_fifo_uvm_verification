class fifo_env extends uvm_env;

    `uvm_component_utils(fifo_env)

    fifo_agent      agent;
    fifo_scoreboard scoreboard;
    fifo_coverage   coverage;

    virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_env")
        end

        // Set vif BEFORE creating agent
        uvm_config_db#(virtual fifo_if)::set(this, "agent", "vif", vif);

        // Create components
        agent      = fifo_agent     ::type_id::create("agent", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
        coverage   = fifo_coverage  ::type_id::create("coverage", this);

        agent.is_active = UVM_ACTIVE;
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.monitor.analysis_port.connect(scoreboard.analysis_imp);
        agent.monitor.analysis_port.connect(coverage.analysis_imp);
    endfunction

endclass
