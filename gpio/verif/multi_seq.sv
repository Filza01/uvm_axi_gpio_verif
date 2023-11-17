// import mem_model_pkg::*;

class multi_seq extends uvm_sequence;
`uvm_object_utils(multi_seq)

    //mem_model instance
    // mem_model  memory_instance;   

    //2 sequence instances: data and instruction 
    wr_seq write_seq;
    rd_seq read_seq;
   
    `uvm_declare_p_sequencer(multi_sequencer)
    
    function new (string name = "multi_seq");
        super.new(name);
        write_seq = wr_seq :: type_id :: create ("write_seq");
        read_seq  = rd_seq :: type_id :: create ("read_seq");
    endfunction

    virtual task body();
        // inst_mem.memory_instance = memory_instance;
        // data_mem.memory_instance = memory_instance;
        
        fork
        write_seq.start(p_sequencer.write_sequencer);
        read_seq.start(p_sequencer.read_sequencer);
        join

    endtask


endclass
