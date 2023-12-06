class axi_base_seq extends uvm_sequence #(axi_seq_item);
    `uvm_object_utils(axi_base_seq)

    axi_seq_item axi_pkt;
    
    function new (string name = "axi_base_seq");
        super.new(name);
    endfunction
endclass

class axi_write_seq extends axi_base_seq;
    `uvm_object_utils(axi_write_seq)
    rand logic [C_S_AXI_ADDR_WIDTH-1:0] addr;
    rand logic [C_S_AXI_DATA_WIDTH-1:0] data;
    rand logic [(C_S_AXI_DATA_WIDTH/8)-1:0] strb; 
    
    function new (string name = "axi_write_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_do_with (axi_pkt, {axi_pkt.s_axi_awaddr == addr; axi_pkt.s_axi_wdata == data; axi_pkt.s_axi_wstrb == strb;})
    endtask
endclass

// --------------------------------
// ------ Write Sequences ---------
// --------------------------------
class axi_write_tir_1_in extends axi_base_seq;
    `uvm_object_utils(axi_write_tir_1_in)

    axi_write_seq wr_seq;
    
    function new (string name = "axi_write_tir_1_in");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write TIR 1 in sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 4; wr_seq.data == 32'hffffffff; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write TIR 1 in sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_write_tir_1_out extends axi_base_seq;
    `uvm_object_utils(axi_write_tir_1_out)

    axi_write_seq wr_seq;
    
    function new (string name = "axi_write_tir_1_out");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write TIR 1 out sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 4; wr_seq.data == 32'h0; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write TIR 1 out sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_write_data_1 extends axi_base_seq;
    `uvm_object_utils(axi_write_data_1)

    axi_write_seq wr_seq;
    
    function new (string name = "axi_write_data_1");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write DATA 1 sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 0; wr_seq.data == 32'h34343434; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write DATA 1 sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_write_tir_2_in extends axi_base_seq;
    `uvm_object_utils(axi_write_tir_2_in)

    axi_write_seq wr_seq;
    
    function new (string name = "axi_write_tir_2_in");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write TIR 2 in sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'hc; wr_seq.data == 32'hffffffff; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write TIR 2 in sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_write_tir_2_out extends axi_base_seq;
    `uvm_object_utils(axi_write_tir_2_out)

    axi_write_seq wr_seq;
    
    function new (string name = "axi_write_tir_2_out");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write TIR 2 out sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'hc; wr_seq.data == 32'h0; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write TIR 2 out sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_write_data_2 extends axi_base_seq;
    `uvm_object_utils(axi_write_data_2)

    axi_write_seq wr_seq;
    
    function new (string name = "axi_write_data_2");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write DATA 2 sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 8; wr_seq.data == 32'h43434343; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write DATA 2 sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_write_GIER extends axi_base_seq;
    `uvm_object_utils(axi_write_GIER)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_GIER");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write GLOBAL INTERRUPT sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h11c; wr_seq.data == 32'h80000000; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write GLOBAL INTERRUPT sequence ended", UVM_LOW)
    endtask
endclass 

class axi_write_IPIER_1 extends axi_base_seq;
    `uvm_object_utils(axi_write_IPIER_1)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_IPIER_1");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write channel 1 IPIER sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h128; wr_seq.data == 32'h1; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write channel 1 IPIER sequence ended", UVM_LOW)
    endtask
endclass 

class axi_write_IPIER_2 extends axi_base_seq;
    `uvm_object_utils(axi_write_IPIER_2)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_IPIER_2");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write channel 2 IPIER sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h128; wr_seq.data == 32'h2; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write channel 2 IPIER sequence ended", UVM_LOW)
    endtask
endclass 

class axi_write_IPIER_1_2 extends axi_base_seq;
    `uvm_object_utils(axi_write_IPIER_1_2)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_IPIER_1_2");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write channel 1 & 2 IPIER sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h128; wr_seq.data == 32'h3; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write channel 1 & 2 IPIER sequence ended", UVM_LOW)
    endtask
endclass 

class axi_write_IPISR_1 extends axi_base_seq;
    `uvm_object_utils(axi_write_IPISR_1)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_IPISR_1");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write channel 1 IPISR sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h120; wr_seq.data == 32'h1; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write channel 1 IPISR sequence ended", UVM_LOW)
    endtask
endclass 

class axi_write_IPISR_2 extends axi_base_seq;
    `uvm_object_utils(axi_write_IPISR_2)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_IPISR_2");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write channel 2 IPISR sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h120; wr_seq.data == 32'h2; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write channel 2 IPISR sequence ended", UVM_LOW)
    endtask
endclass 

class axi_write_IPISR_1_2 extends axi_base_seq;
    `uvm_object_utils(axi_write_IPISR_1_2)

    axi_write_seq wr_seq;

    function new(string name = "axi_write_IPISR_1_2");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI write channel 1 & 2 IPISR sequence", UVM_LOW)
        `uvm_do_with(wr_seq, {wr_seq.addr == 9'h120; wr_seq.data == 32'h3; wr_seq.strb == 4'hf;})
        `uvm_info(get_type_name(), "AXI write channel 1 & 2 IPISR sequence ended", UVM_LOW)
    endtask
endclass 

// --------------------------------
// ------ Read Sequences ----------
// --------------------------------
class axi_read_seq extends axi_base_seq;
    `uvm_object_utils(axi_read_seq)
    rand logic [C_S_AXI_ADDR_WIDTH-1:0] addr;
    
    function new (string name = "axi_read_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_do_with (axi_pkt, {axi_pkt.s_axi_araddr == addr;})
    endtask
endclass

class axi_read_data_1 extends axi_base_seq;
    `uvm_object_utils(axi_read_data_1)

    axi_read_seq rd_seq;
    
    function new (string name = "axi_read_data_1");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read DATA 1 sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 0;})
        `uvm_info(get_type_name(), "AXI read DATA 1 sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_read_tir_1 extends axi_base_seq;
    `uvm_object_utils(axi_read_tir_1)

    axi_read_seq rd_seq;
    
    function new (string name = "axi_read_tir_1");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read TIR 1 sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 4;})
        `uvm_info(get_type_name(), "AXI read TIR 1 sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_read_data_2 extends axi_base_seq;
    `uvm_object_utils(axi_read_data_2)

    axi_read_seq rd_seq;
    
    function new (string name = "axi_read_data_2");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read DATA 2 sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 8;})
        `uvm_info(get_type_name(), "AXI read DATA 2 sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_read_tir_2 extends axi_base_seq;
    `uvm_object_utils(axi_read_tir_2)

    axi_read_seq rd_seq;
    
    function new (string name = "axi_read_tir_2");
        super.new(name);
    endfunction

     virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read TIR 2 sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 9'hc;})
        `uvm_info(get_type_name(), "AXI read TIR 2 sequence ended", UVM_LOW)
    endtask : body
endclass

class axi_read_GIER extends axi_base_seq;
    `uvm_object_utils(axi_read_GIER)

    axi_read_seq rd_seq;

    function new(string name = "axi_read_GIER");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read GLOBAL INTERRUPT sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 9'h11c;})
        `uvm_info(get_type_name(), "AXI read GLOBAL INTERRUPT sequence ended", UVM_LOW)
    endtask
endclass 

class axi_read_IPIER extends axi_base_seq;
    `uvm_object_utils(axi_read_IPIER)

    axi_read_seq rd_seq;

    function new(string name = "axi_read_IPIER");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read IPIER sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 9'h128;})
        `uvm_info(get_type_name(), "AXI read IPIER sequence ended", UVM_LOW)
    endtask
endclass 

class axi_read_IPISR extends axi_base_seq;
    `uvm_object_utils(axi_read_IPISR)

    axi_read_seq rd_seq;

    function new(string name = "axi_read_IPISR");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), "Executing AXI read IPISR sequence", UVM_LOW)
        `uvm_do_with(rd_seq, {rd_seq.addr == 9'h120;})
        `uvm_info(get_type_name(), "AXI read IPISR sequence ended", UVM_LOW)
    endtask
endclass 
