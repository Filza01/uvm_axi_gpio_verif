// import mem_model_pkg::*;

class axi_base_seq extends uvm_sequence #(axi_seq_item);
    `uvm_object_utils(axi_base_seq)

    axi_seq_item axi_pkt;
    
    function new (string name = "axi_base_seq");
        super.new(name);
    endfunction

    // task pre_body();
    //     uvm_phase phase;
    //     `ifdef UVM_VERSION_1_2
    //       // in UVM1.2, get starting phase from method
    //       phase = get_starting_phase();
    //     `else
    //       phase = starting_phase;
    //     `endif
    //     if (phase != null) begin
    //       phase.raise_objection(this, get_type_name());
    //       `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    //     end
    //   endtask : pre_body
    
    //   task post_body();
    //     uvm_phase phase;
    //     `ifdef UVM_VERSION_1_2
    //       // in UVM1.2, get starting phase from method
    //       phase = get_starting_phase();
    //     `else
    //       phase = starting_phase;
    //     `endif
    //     if (phase != null) begin
    //       phase.drop_objection(this, get_type_name());
    //       `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    //     end
    //   endtask : post_body

endclass


class axi_write_seq_tir extends axi_base_seq;
`uvm_object_utils(axi_write_seq_tir)
    
    function new (string name = "axi_write_seq_tir");
        super.new(name);
    endfunction

     virtual task body();
        axi_pkt = axi_seq_item::type_id::create ("axi_pkt"); 

        start_item(axi_pkt);
        `uvm_info(get_type_name(), "Executing AXI write TIR sequence", UVM_LOW)

        axi_pkt.s_axi_awaddr = 4;
        axi_pkt.s_axi_wdata = 0;
        axi_pkt.s_axi_wstrb = 4'hf;

        `uvm_info(get_type_name(), "AXI write TIR sequence ended", UVM_LOW)
        finish_item(axi_pkt);
   
    endtask : body
endclass

class axi_read_seq_data extends axi_base_seq;
    `uvm_object_utils(axi_read_seq_data)
        
        function new (string name = "axi_read_seq_data");
            super.new(name);
        endfunction
    
         virtual task body();
            axi_pkt = axi_seq_item::type_id::create ("axi_pkt"); 
    
            start_item(axi_pkt);
            `uvm_info(get_type_name(), "Executing AXI read DATA sequence", UVM_LOW)
    
            axi_pkt.s_axi_araddr = 0;
    
            `uvm_info(get_type_name(), "AXI read DATA sequence ended", UVM_LOW)
            finish_item(axi_pkt);
      endtask : body
endclass

class axi_write_seq_data extends axi_base_seq;
`uvm_object_utils(axi_write_seq_data)
    
    function new (string name = "axi_write_seq_data");
        super.new(name);
    endfunction

     virtual task body();
        axi_pkt = axi_seq_item::type_id::create ("axi_pkt"); 

        start_item(axi_pkt);
        `uvm_info(get_type_name(), "Executing AXI write DATA sequence", UVM_LOW)

        axi_pkt.s_axi_awaddr = 0;
        axi_pkt.s_axi_wdata = 53743;
        axi_pkt.s_axi_wstrb = 4'hf;

        `uvm_info(get_type_name(), "AXI write DATA sequence ended", UVM_LOW)
        finish_item(axi_pkt);
  endtask : body
endclass

class axi_read_seq_tri extends axi_base_seq;
    `uvm_object_utils(axi_read_seq_tri)
        
        function new (string name = "axi_read_seq_tri");
            super.new(name);
        endfunction
    
         virtual task body();
            axi_pkt = axi_seq_item::type_id::create ("axi_pkt"); 
    
            start_item(axi_pkt);
            `uvm_info(get_type_name(), "Executing AXI read TRI sequence", UVM_LOW)
    
            axi_pkt.s_axi_araddr = 4;
    
            `uvm_info(get_type_name(), "AXI read TRI sequence ended", UVM_LOW)
            finish_item(axi_pkt);
      endtask : body
endclass
