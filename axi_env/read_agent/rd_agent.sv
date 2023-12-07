class rd_agent extends uvm_agent;
 
  `uvm_component_utils(rd_agent)

  rd_monitor   monitor;
  rd_sequencer sequencer;
  rd_driver    driver;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = rd_monitor::type_id::create("monitor", this);
    sequencer = rd_sequencer::type_id::create("sequencer", this);
    driver = rd_driver::type_id::create("driver", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass