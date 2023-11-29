// import mem_model_pkg::*;

class gpio_seqs extends uvm_sequence #(gpio_seq_item);
    `uvm_object_utils(axi_seqs)
    
        //mem_model instance
        // mem_model  memory_instance;   
    
        //2 sequence instances: data and instruction 
        // wr_seq write_seq;
        // rd_seq read_seq;
       
        // `uvm_declare_p_sequencer(multi_sequencer)
        gpio_seq_item gpio_pkt;
        
        function new (string name = "gpio_seqs");
            super.new(name);
            // write_seq = wr_seq :: type_id :: create ("write_seq");
            // read_seq  = rd_seq :: type_id :: create ("read_seq");
        endfunction
    
    endclass
    
    
    class gpio_seq extends gpio_seqs #(gpio_seq_item);
    `uvm_object_utils(gpio_seq)
    
        //mem_model instance
        // mem_model  memory_instance;   
    
        //2 sequence instances: data and instruction 
        // wr_seq write_seq;
        // rd_seq read_seq;
       
        // `uvm_declare_p_sequencer(multi_sequencer)
        // axi_seq_item axi_pkt;
        
        function new (string name = "gpio_seq");
            super.new(name);
            // write_seq = wr_seq :: type_id :: create ("write_seq");
            // read_seq  = rd_seq :: type_id :: create ("read_seq");
        endfunction
    
         virtual task body();
        `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
        `uvm_do_with(gpio_pkt, 
            { gpio_pkt.gpio_io_i == 4;})
        // `uvm_info(get_type_name(), $sformatf("AXI WRITE ADDRESS:%0d  DATA:%h", address, data), UVM_MEDIUM)
      endtask : body
    endclass
    