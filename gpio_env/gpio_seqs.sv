// import mem_model_pkg::*;

class gpio_base_seq extends uvm_sequence #(gpio_seq_item);
    `uvm_object_utils(gpio_base_seq)

        gpio_seq_item gpio_pkt;
        
        function new (string name = "gpio_base_seq");
            super.new(name);
        endfunction
    
    endclass
    class gpio_seq extends gpio_base_seq;
    `uvm_object_utils(gpio_seq)
        
        function new (string name = "gpio_seq");
            super.new(name);
        endfunction
    
        virtual task body();
            gpio_pkt = gpio_seq_item::type_id::create ("gpio_pkt"); 
    
            start_item(gpio_pkt);
            `uvm_info(get_type_name(), "Executing GPIO sequence", UVM_LOW)
    
            gpio_pkt.gpio_io_i = 32'h22222222;
    
            `uvm_info(get_type_name(), "GPIO sequence ended", UVM_LOW)
            finish_item(gpio_pkt);
       
        endtask : body
    endclass
    