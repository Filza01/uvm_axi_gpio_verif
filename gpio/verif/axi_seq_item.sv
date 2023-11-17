class axi_seq_item extends uvm_sequence_item;

`uvm_object_utils (axi_seq_item) //factory registeration

// ---------------
// -- axi write address channel signals
//---------------
logic [C_S_AXI_ADDR_WIDTH-1: 0] s_axi_awaddr   ;
logic s_axi_awvalid  ;
logic s_axi_awready  ;
// ---------------
// -- axi write data channel signals
//---------------
logic [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata    ;
logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb    ;
logic s_axi_wvalid   ;
logic s_axi_wready   ;
// ---------------
// -- axi write response channel signals
// ---------------
logic [1:0] s_axi_bresp    ;
logic s_axi_bvalid   ;
logic s_axi_bready   ;
// ---------------
// -- axi read address channel signals
// ---------------
logic [C_S_AXI_ADDR_WIDTH-1: 0] s_axi_araddr   ;
logic s_axi_arvalid  ;
logic s_axi_arready  ;
// ---------------
// -- axi read address channel signals
// ---------------
logic [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata    ;
logic [1:0] s_axi_rresp    ;
logic s_axi_rvalid   ;
logic s_axi_rready   ;
//-------------------------------

endclass //axi_seq_item extends uvm_sequence_item