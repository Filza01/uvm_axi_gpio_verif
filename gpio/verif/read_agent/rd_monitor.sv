`define `MON_IF vif.mon_cb
class rd_monitor extends uvm_monitor;
  `uvm_component_utils(rd_monitor)
  uvm_analysis_port #(axi_seq_item) read_port;

   virtual axi_intf axi_vif;
   axi_seq_item axi_pkt;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    read_port=new("read_port",this)
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db::get(this,"","axi_vif", axi_vif))
      `uvm_fatal(get_type_name(),"Could not get AXI interface");
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    forever begin
      axi_pkt=axi_seq_item::type_id::create("axi_pkt", this);
      @(`MON_IF.s_axi_arready);
      axi_pkt.s_axi_araddr = `MON_IF.s_axi_araddr;
      @(`MON_IF.s_axi_rvalid);
      if (`MON_IF.s_axi_rresp==0) begin
        axi_pkt.s_axi_rdata = `MON_IF.s_axi_rdata;
      end
    read_port.write(axi_pkt);
    end
  endtask

endclass //rd_monitor extends uvm_monitor