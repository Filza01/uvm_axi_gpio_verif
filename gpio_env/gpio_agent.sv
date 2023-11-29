class gpio_agent extends uvm_agent;
    `uvm_component_utils(gpio_agent);

    gpio_sequencer seqr;
    gpio_monitor mon;
    gpio_driver drv;

    function new(string name = "gpio_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = gpio_sequencer::type_id::create("seqr",this);
        drv = gpio_driver::type_id::create("drv",this);
        mon = gpio_monitor::type_id::create("mon",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
        // mon.axi_port_item.connect();
    endfunction
    
endclass 