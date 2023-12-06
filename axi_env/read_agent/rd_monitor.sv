`define MON_IF axi_if.cb_monitor
class rd_monitor extends uvm_monitor;
  `uvm_component_utils(rd_monitor)
  uvm_analysis_port #(axi_seq_item) read_port;

   virtual axi_intf axi_if;
   axi_seq_item axi_pkt;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    read_port=new("read_port",this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual axi_intf)::get(this,"*","axi_if",axi_if)) begin
      `uvm_fatal ("AXI_WR_DRIVER","Failed to get axi_if")
    end
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    wait(tb_top.reset == 1'b1);
    forever begin
      axi_pkt=axi_seq_item::type_id::create("axi_pkt", this);
      `uvm_info(get_full_name,"AXI Read monitor class started", UVM_NONE)
      fork
        // read address channel
        begin
          @(posedge `MON_IF.s_axi_arready);
          axi_pkt.s_axi_araddr = `MON_IF.s_axi_araddr;
          axi_pkt.s_axi_arvalid = `MON_IF.s_axi_arvalid;
          axi_pkt.s_axi_arready = `MON_IF.s_axi_arready;
        end

        // read data and response channel
        begin
          @(posedge `MON_IF.s_axi_rvalid);
          if (`MON_IF.s_axi_rresp==0) begin
            axi_pkt.s_axi_rdata = `MON_IF.s_axi_rdata;
            axi_pkt.s_axi_rresp = `MON_IF.s_axi_rresp;
            axi_pkt.s_axi_rvalid = `MON_IF.s_axi_rvalid;
            axi_pkt.s_axi_rready = `MON_IF.s_axi_rready;
          end
        end
      join
        @(posedge axi_if.clk);
      
      read_port.write(axi_pkt);
      `uvm_info(get_full_name(),$sformatf("In AXI Read monitor, \n\t\t s_axi_araddr = %h, \n\t\t s_axi_arready = %h, \n\t\t s_axi_arvalid = %h, \n\t\t s_axi_rready = %h, \n\t\t s_axi_rdata = %h, \n\t\t s_axi_rvalid = %h, \n\t\t s_axi_rresp = %h", `MON_IF.s_axi_araddr, `MON_IF.s_axi_arready, `MON_IF.s_axi_arvalid, `MON_IF.s_axi_rready, `MON_IF.s_axi_rdata, `MON_IF.s_axi_rvalid, `MON_IF.s_axi_rresp), UVM_NONE) 
      `uvm_info(get_full_name,"Data written to port item", UVM_NONE)
      `uvm_info(get_full_name,"AXI Write monitor class ended", UVM_NONE)
    end
  endtask

endclass //rd_monitor extends uvm_monitor