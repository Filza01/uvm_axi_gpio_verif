class multi_sequencer extends uvm_sequencer;
    `uvm_component_utils(multi_sequencer)

    wr_sequencer     write_sequencer;
    rd_sequencer     read_sequencer;
     
    
   function new(string name ,uvm_component parent);
        super.new(name,parent);
    endfunction 
    
endclass