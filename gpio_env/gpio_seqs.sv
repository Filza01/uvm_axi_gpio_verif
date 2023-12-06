class gpio_base_seq extends uvm_sequence #(gpio_seq_item);
    `uvm_object_utils(gpio_base_seq)

        gpio_seq_item gpio_pkt;
        
        function new (string name = "gpio_base_seq");
            super.new(name);
        endfunction
    
endclass

class gpio_seq extends gpio_base_seq;
    `uvm_object_utils(gpio_seq)
    rand logic [C_GPIO_WIDTH-1:0] in1;
    rand logic [C_GPIO2_WIDTH-1:0] in2;
        
    function new (string name = "gpio_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_do_with (gpio_pkt, {gpio_pkt.gpio_io_i == in1; gpio_pkt.gpio2_io_i == in2;})
    endtask : body
endclass

class gpio_seq_channel_1_in extends gpio_base_seq;
    `uvm_object_utils(gpio_seq_channel_1_in)
    gpio_seq seq_gpio;

    function new (string name = "gpio_seq_channel_in");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing GPIO channel 1 input sequence", UVM_LOW)
        `uvm_do_with (seq_gpio, {seq_gpio.in1 == 32'h22222222;})
        `uvm_info(get_type_name(), "GPIO channel 1 input sequence ended", UVM_LOW)
    endtask
endclass

class gpio_seq_channel_2_in extends gpio_base_seq;
    `uvm_object_utils(gpio_seq_channel_2_in)
    gpio_seq seq_gpio;

    function new (string name = "gpio_seq_channel_2_in");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing GPIO channel 2 input sequence", UVM_LOW)
        `uvm_do_with (seq_gpio, {seq_gpio.in2 == 32'h22222222;})
        `uvm_info(get_type_name(), "GPIO channel 2 input sequence ended", UVM_LOW)
    endtask
endclass

    