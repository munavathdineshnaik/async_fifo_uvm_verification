class fifo_env extends uvm_env;

    `uvm_component_utils(fifo_env)

    // Components
    fifo_agent      agent;
    fifo_scoreboard scoreboard;
    fifo_coverage   coverage;

    // Virtual interface
    virtual fifo_if vif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get virtual interface from test
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set for fifo_env")
        end

        // Create components
        agent      = fifo_agent     ::type_id::create("agent", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
        coverage   = fifo_coverage  ::type_id::create("coverage", this);

        // Configure agent
        agent.is_active = UVM_ACTIVE;

        // Passing virtual interface to agent
        uvm_config_db#(virtual fifo_if)::set(this, "agent", "vif", vif);
    endfunction


    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Monitor -> Scoreboard
        agent.monitor.analysis_port.connect(scoreboard.analysis_imp);

        // Monitor -> Coverage
        agent.monitor.analysis_port.connect(coverage.analysis_imp);
    endfunction

endclass

