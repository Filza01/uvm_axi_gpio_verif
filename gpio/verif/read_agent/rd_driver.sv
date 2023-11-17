`define `DRV_IF vif.drv
class rd_driver extends uvm_driver #(axi_seq_item) ;
`uvm_component_utils(rd_driver)

  axi_seq_item axi_pkt;
  virtual axi_intf axi_vif;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db::get(this,"","axi_vif", axi_vif))
      `uvm_fatal(get_type_name(),"Could not get AXI interface");
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(axi_pkt); 
    drive();
    seq_item_port.item_done();
    end
  endtask

  task  drive();
    fork
      begin
        //Read Address Channel
        `DRV_IF.s_axi_arvalid <= axi_pkt.s_axi_arvalid;
        `DRV_IF.s_axi_araddr <= axi_pkt.s_axi_araddr;
        @(`DRV_IF.s_axi_arready);
      end

      begin
        //Read Data Channel
        `DRV_IF.s_axi_rready <= 1;
        @(`DRV_IF.s_axi_rvalid);
        axi_pkt.s_axi_rdata = `DRV_IF.s_axi_rdata;
      end
    join
    @(posedge vif.clk)
  endtask //




endclass //rd_driver extends uvm_driver 