`define DRIV_IF axi_if.cb_driver

class wr_driver extends uvm_driver #(axi_seq_item);
    `uvm_component_utils(wr_driver)
    
    axi_seq_item axi_inst;
    virtual axi_intf axi_if;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual axi_intf)::get(this,"*","axi_if",axi_if)) begin
            `uvm_fatal ("AXI_WR_DRIVER","Failed to get axi_if")
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        wait(tb_top.reset == 1'b1);
        forever begin
            // `uvm_info(get_full_name(), "AXI Write Driver Started", UVM_NONE)
            seq_item_port.get_next_item(axi_inst);  
            drive();
            seq_item_port.item_done();
            // `uvm_info(get_full_name(), "AXI Write Driver done", UVM_NONE)
        end
    endtask

    task drive();
        fork
            // write address channel
            begin
                `DRIV_IF.s_axi_awvalid <= 1;
                `DRIV_IF.s_axi_awaddr <= axi_inst.s_axi_awaddr;
                wait(`DRIV_IF.s_axi_awready==1);
                axi_if.clk_pos(1);
                `DRIV_IF.s_axi_awvalid <= 0;
            end
            
            // write data channel
            begin
                `DRIV_IF.s_axi_wvalid <= 1;
                `DRIV_IF.s_axi_wdata <= axi_inst.s_axi_wdata;
                `DRIV_IF.s_axi_wstrb <= axi_inst.s_axi_wstrb;
                wait(`DRIV_IF.s_axi_wready==1);
                axi_if.clk_pos(1);
                `DRIV_IF.s_axi_wvalid <= 0;
            end

            // response channel
            begin
                `DRIV_IF.s_axi_bready <= 1;
                wait(`DRIV_IF.s_axi_bvalid==1);
                axi_if.clk_pos(1);
                `DRIV_IF.s_axi_bready <= 0;
            end
        join
            @(posedge axi_if.clk);
    endtask
    
endclass