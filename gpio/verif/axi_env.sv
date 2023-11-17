class axi_env extends uvm_env;
    `uvm_component_utils(env);

    wr_agent write_agent;
    rd_agent read_agent;

    multi_sequencer sequencer;

    function new(string name = "axi_env", uvm_component parent = null);
        super.new(name , parent);
    endfunction

    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        write_agent = wr_agent::type_id::create("write_agent",this);
        read_agent = rd_agent::type_id::create("read_agent",this);
        sequencer = multi_sequencer::type_id::create("sequencer",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        sequencer.write_sequencer = write_agent.seqr;
        sequencer.read_sequencer = read_agent.sequencer;
    endfunction

endclass 