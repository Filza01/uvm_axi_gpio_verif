class rd_sequencer extends uvm_sequencer #(axi_seq_item);
  `uvm_component_utils(rd_sequencer )// factory registeration

     // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass //rd_sequencer extends uvm_sequencer