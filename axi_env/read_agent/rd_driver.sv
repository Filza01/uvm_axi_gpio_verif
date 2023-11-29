
`define DRV_IF axi_if.cb_driver
class rd_driver extends uvm_driver #(axi_seq_item) ;
`uvm_component_utils(rd_driver)

  axi_seq_item axi_pkt;
  virtual axi_intf axi_if;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual axi_intf)::get(this,"*","axi_if",axi_if)) begin
      `uvm_fatal ("AXI_WR_DRIVER","Failed to get axi_if")
    end
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    forever begin
      `uvm_info(get_full_name(), "AXI Read Driver Started", UVM_NONE)
      seq_item_port.get_next_item(axi_pkt); 
      drive();
      seq_item_port.item_done();
      `uvm_info(get_full_name(), "AXI Read Driver done", UVM_NONE)
    end
  endtask

  task  drive();
    fork
      begin
        //Read Address Channel
        `DRV_IF.s_axi_arvalid <= 1;
        `DRV_IF.s_axi_araddr <= axi_pkt.s_axi_araddr;
        wait(`DRV_IF.s_axi_arready==1);
        axi_if.clk_pos(1);
        `DRV_IF.s_axi_arvalid <= 0;
      end

      begin
        //Read Data Channel
        `DRV_IF.s_axi_rready <= 1;
        wait(`DRV_IF.s_axi_rvalid==1);
        axi_if.clk_pos(1);
        `DRV_IF.s_axi_rready <= 0;
      end
    join
    @(posedge axi_if.clk);
  endtask //




endclass //rd_driver extends uvm_driver 