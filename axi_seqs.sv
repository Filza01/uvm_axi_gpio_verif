// import mem_model_pkg::*;

class axi_seqs extends uvm_sequence #(axi_seq_item);
`uvm_object_utils(axi_seqs)

    //mem_model instance
    // mem_model  memory_instance;   

    //2 sequence instances: data and instruction 
    // wr_seq write_seq;
    // rd_seq read_seq;
   
    // `uvm_declare_p_sequencer(multi_sequencer)
    axi_seq_item axi_pkt;
    
    function new (string name = "axi_seqs");
        super.new(name);
        // write_seq = wr_seq :: type_id :: create ("write_seq");
        // read_seq  = rd_seq :: type_id :: create ("read_seq");
    endfunction

endclass


class axi_write_seq extends axi_seqs #(axi_seq_item);
`uvm_object_utils(axi_write_seq)

    //mem_model instance
    // mem_model  memory_instance;   

    //2 sequence instances: data and instruction 
    // wr_seq write_seq;
    // rd_seq read_seq;
   
    // `uvm_declare_p_sequencer(multi_sequencer)
    // axi_seq_item axi_pkt;
    
    function new (string name = "axi_write_seq");
        super.new(name);
        // write_seq = wr_seq :: type_id :: create ("write_seq");
        // read_seq  = rd_seq :: type_id :: create ("read_seq");
    endfunction

     virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do_with(axi_pkt, 
        { axi_pkt.s_axi_awaddr == 4;})
    // `uvm_info(get_type_name(), $sformatf("AXI WRITE ADDRESS:%0d  DATA:%h", address, data), UVM_MEDIUM)
  endtask : body
endclass

class axi_read_seq extends axi_seqs #(axi_seq_item);
`uvm_object_utils(axi_read_seq)

    //mem_model instance
    // mem_model  memory_instance;   

    //2 sequence instances: data and instruction 
    // wr_seq write_seq;
    // rd_seq read_seq;
   
    // `uvm_declare_p_sequencer(multi_sequencer)
    // axi_seq_item axi_pkt;
    
    function new (string name = "axi_read_seq");
        super.new(name);
        // write_seq = wr_seq :: type_id :: create ("write_seq");
        // read_seq  = rd_seq :: type_id :: create ("read_seq");
    endfunction

     virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do_with(axi_pkt, 
        { axi_pkt.s_axi_araddr == 4;})
    // `uvm_info(get_type_name(), $sformatf("AXI READ ADDRESS:%0d", address), UVM_MEDIUM)
  endtask : body
endclass