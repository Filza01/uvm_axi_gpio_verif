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
            // axi_if.clk_pos(3);

            // i think i have to do bit by bit

            gpio_port.write(gpio_inst);
            // `uvm_info(get_full_name(),$sformatf("In GPIO monitor, \n\t\t s_axi_awaddr = %h, \n\t\t s_axi_awready = %h, \n\t\t s_axi_awvalid = %h, \n\t\t s_axi_wready = %h, \n\t\t s_axi_wdata = %h, \n\t\t s_axi_wstrb = %h, \n\t\t s_axi_wvalid = %h, \n\t\t s_axi_bready = %h, \n\t\t s_axi_bresp = %h, \n\t\t s_axi_bvalid = %h", `MON_IF.s_axi_awaddr, `MON_IF.s_axi_awready, `MON_IF.s_axi_awvalid, `MON_IF.s_axi_wready, `MON_IF.s_axi_wdata, `MON_IF.s_axi_wstrb, `MON_IF.s_axi_wvalid, `MON_IF.s_axi_bready, `MON_IF.s_axi_bresp, `MON_IF.s_axi_bvalid), UVM_NONE) 
            // `uvm_info(get_full_name,"Data written to port item", UVM_NONE)
            `uvm_info(get_full_name,"GPIO monitor class ended", UVM_NONE)
        end
    endtask
endclass 