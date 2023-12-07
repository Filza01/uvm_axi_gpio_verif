class wr_agent extends uvm_agent;
    `uvm_component_utils(wr_agent);

    wr_sequencer seqr;
    wr_monitor mon;
    wr_driver drv;

    function new(string name = "wr_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = wr_sequencer::type_id::create("seqr",this);
        drv = wr_driver::type_id::create("drv",this);
        mon = wr_monitor::type_id::create("mon",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
    
endclass 