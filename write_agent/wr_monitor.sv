`define MON_IF axi_if.cb_monitor
class wr_monitor extends uvm_monitor;
    `uvm_component_utils(wr_monitor)

    virtual axi_intf axi_if;

    // uvm_analysis_port #(axi_seq_item) axi_port_item;

    axi_seq_item axi_inst;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);  
    endfunction 

    function void build_phase (uvm_phase phase); 
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual axi_intf)::get(this,"","axi_if",axi_if))begin
            `uvm_fatal("NOMEM_IF",{"Virtual interface must be set for:",get_full_name(),".axi_if"});
            end
        // axi_port_item = new("axi_port_item",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        // wait(tb_top.reset == 1'b1);
        forever begin
            `uvm_info(get_full_name,"AXI Write monitor class started", UVM_NONE)
            axi_inst = axi_seq_item::type_id::create("axi_inst",this);
            axi_if.clk_pos(3);

            axi_inst.s_axi_awaddr = `MON_IF.s_axi_awaddr;
            axi_inst.s_axi_awready = `MON_IF.s_axi_awready;
            axi_inst.s_axi_awvalid = `MON_IF.s_axi_awvalid;

            axi_inst.s_axi_wready = `MON_IF.s_axi_wready;
            axi_inst.s_axi_wdata = `MON_IF.s_axi_wdata;
            axi_inst.s_axi_wstrb = `MON_IF.s_axi_wstrb;
            axi_inst.s_axi_wvalid = `MON_IF.s_axi_wvalid;

            axi_inst.s_axi_bready = `MON_IF.s_axi_bready;
            axi_inst.s_axi_bresp = `MON_IF.s_axi_bresp;
            axi_inst.s_axi_bvalid = `MON_IF.s_axi_bvalid;

            // axi_port_item.write(axi_inst);
            // `uvm_info(get_full_name(),$sformatf("In AXI Write monitor, \n\t\t s_axi_awaddr = %h,
            // \n\t\t s_axi_awready = %h, \n\t\t s_axi_awvalid = %h, \n\t\t s_axi_wready = %h, 
            // \n\t\t s_axi_wdata = %h, \n\t\t s_axi_wstrb = %h, \n\t\t s_axi_wvalid = %h, 
            // \n\t\t s_axi_bready = %h, \n\t\t s_axi_bresp = %h, \n\t\t s_axi_bvalid = %h",
            // `MON_IF.s_axi_awaddr, `MON_IF.s_axi_awready, `MON_IF.s_axi_awvalid, `MON_IF.s_axi_wready,
            // `MON_IF.s_axi_wdata, `MON_IF.s_axi_wstrb, `MON_IF.s_axi_wvalid, `MON_IF.s_axi_bready, 
            // `MON_IF.s_axi_bresp, `MON_IF.s_axi_bvalid), UVM_NONE)
            // `uvm_info(get_full_name,"Data written to port item", UVM_NONE)
            `uvm_info(get_full_name,"AXI Write monitor class ended", UVM_NONE)
        end
    endtask
endclass 