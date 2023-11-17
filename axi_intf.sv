interface axi_intf #(C_S_AXI_ADDR_WIDTH = 9, C_S_AXI_DATA_WIDTH = 32) (input clk);
    // AW channel
    bit [C_S_AXI_ADDR_WIDTH-1:0]        s_axi_awaddr; 
    bit                                 s_axi_awvalid;
    bit                                 s_axi_awready;  
    // W channel 
    bit [C_S_AXI_DATA_WIDTH-1:0]        s_axi_wdata;  
    bit [(C_S_AXI_DATA_WIDTH/8)-1:0]    s_axi_wstrb; 
    bit                                 s_axi_wvalid;
    bit                                 s_axi_wready;
    // B channel
    bit [1:0]                           s_axi_bresp; 
    bit                                 s_axi_bvalid;
    bit                                 s_axi_bready;
    // AR channel
    bit [C_S_AXI_ADDR_WIDTH-1:0]        s_axi_araddr;  
    bit                                 s_axi_arvalid;
    bit                                 s_axi_arready;
    // R channel
    bit [C_S_AXI_DATA_WIDTH-1:0]        s_axi_rdata; 
    bit [1:0]                           s_axi_rresp;
    bit                                 s_axi_rvalid;
    bit                                 s_axi_rready;

    task clk_pos(input int count);
        repeat (count) @(posedge clk);
    endtask

    // driver and monitor clocking blocks 
    clocking cb_driver @(posedge clk);
        default input #1ns output #1ns;
        // AW channel
        output  s_axi_awaddr;             
        output  s_axi_awvalid;           
        input   s_axi_awready;           
        // W channel 
        output s_axi_wdata;              
        output s_axi_wstrb;             
        output s_axi_wvalid;            
        input  s_axi_wready;          
        // B channel
        input  s_axi_bresp;          
        input  s_axi_bvalid;            
        output s_axi_bready;      
        // AR channel
        output s_axi_araddr;         
        output s_axi_arvalid;       
        input  s_axi_arready;   
        // R channel
        input  s_axi_rdata;             
        input  s_axi_rresp;           
        input  s_axi_rvalid;           
        output s_axi_rready;     
    endclocking

    clocking cb_monitor @(posedge clk);
        default input #1ns output #1ns;
        // AW channel
        input  s_axi_awaddr;             
        input  s_axi_awvalid;           
        input   s_axi_awready;           
        // W channel 
        input s_axi_wdata;              
        input s_axi_wstrb;             
        input s_axi_wvalid;            
        input  s_axi_wready;          
        // B channel
        input  s_axi_bresp;          
        input  s_axi_bvalid;            
        input s_axi_bready;      
        // AR channel
        input s_axi_araddr;         
        input s_axi_arvalid;       
        input  s_axi_arready;   
        // R channel
        input  s_axi_rdata;             
        input  s_axi_rresp;           
        input  s_axi_rvalid;           
        input s_axi_rready; 
    endclocking

endinterface