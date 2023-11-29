`define MON_IF gpio_if.cb_monitor
class gpio_monitor extends uvm_monitor;
    `uvm_component_utils(gpio_monitor)

    virtual gpio_intf gpio_if;

    uvm_analysis_port #(gpio_seq_item) gpio_port;

    gpio_seq_item gpio_inst;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);  
    endfunction 

    function void build_phase (uvm_phase phase); 
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual gpio_intf)::get(this,"","gpio_if",gpio_if))begin
            `uvm_fatal("NOMEM_IF",{"Virtual interface must be set for:",get_full_name(),".gpio_if"});
            end
            gpio_port = new("gpio_port",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        // wait(tb_top.reset == 1'b1);
        forever begin
            `uvm_info(get_full_name,"GPIO monitor class started", UVM_NONE)
            gpio_inst = gpio_seq_item::type_id::create("gpio_inst",this);
            gpio_if.clk_pos(3);
            // gpio_inst.gpio_io_i = `MON_IF.gpio_io_i;
            // gpio_inst.gpio2_io_i = `MON_IF.gpio2_io_i;
            gpio_inst.gpio_io_t = `MON_IF.gpio_io_t;
            gpio_inst.gpio_io_o = `MON_IF.gpio_io_o;
            // gpio_inst.gpio2_io_o = `MON_IF.gpio2_io_o;
            gpio_port.write(gpio_inst);
            `uvm_info(get_full_name,"Data written to port item", UVM_NONE)
            `uvm_info(get_full_name,"GPIO monitor class ended", UVM_NONE)
        end
    endtask
endclass 