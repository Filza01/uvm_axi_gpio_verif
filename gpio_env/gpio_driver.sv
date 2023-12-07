`define DRIV_IF gpio_if.cb_driver

class gpio_driver extends uvm_driver #(gpio_seq_item);
    `uvm_component_utils(gpio_driver)
    
    virtual gpio_intf gpio_if;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual gpio_intf)::get(this,"*","gpio_if",gpio_if)) begin
            `uvm_fatal ("GPIO_DRIVER","Failed to get gpio_if")
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        gpio_seq_item gpio_inst;
        wait(tb_top.reset == 1'b1);
        forever begin
            // `uvm_info(get_full_name(), "GPIO Driver Started", UVM_NONE)

            seq_item_port.get_next_item(gpio_inst); 

            `DRIV_IF.gpio_io_i <= gpio_inst.gpio_io_i;
            `DRIV_IF.gpio2_io_i <= gpio_inst.gpio2_io_i;
            gpio_if.clk_pos(1);
            seq_item_port.item_done();
            // `uvm_info(get_full_name(), "GPIO Driver done", UVM_NONE)
        end
    endtask
    
endclass