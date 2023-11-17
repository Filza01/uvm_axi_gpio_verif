// import uvm_pkg::*;
// `include "uvm_macros.svh";
// import axi_pkg::*;

module tb_top();

    bit clk, reset;

    // clk_rst_if clk_if (
    //     .clk(clk),
    //     .rst_n(reset)
    // );

    axi_intf #(
        .C_S_AXI_ADDR_WIDTH  ( 9),
        .C_S_AXI_DATA_WIDTH  (32)
    ) axi_if (.clk(clk));

    gpio_intf #(
        .C_GPIO_WIDTH       ( 32),
        .C_GPIO2_WIDTH      ( 32)
    ) gpio_if (.clk(clk));

    // initial begin
    //     $dumpfile("waveform.vcd");
    //     $dumpvars();
    // end

    always #10 clk = ~clk;

    initial begin
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        axi_if.s_axi_awaddr = 4;
        axi_if.s_axi_awvalid = 1;
        axi_if.s_axi_wvalid = 1;
        axi_if.s_axi_wdata = 32'h39af1292;
        axi_if.s_axi_wstrb = 7'hff;
        axi_if.s_axi_bready = 1;
        wait(axi_if.s_axi_wready == 1);
        @(posedge clk);
        axi_if.s_axi_awvalid = 0;
        axi_if.s_axi_wvalid = 0;
        wait(axi_if.s_axi_bvalid == 1);
        @(posedge clk);
        axi_if.s_axi_bready = 0;

        @(posedge clk);
        @(posedge clk);

        axi_if.s_axi_araddr = 4;
        axi_if.s_axi_arvalid = 1;
        axi_if.s_axi_rready = 1;
        wait(axi_if.s_axi_arready == 1);
        @(posedge clk);
        axi_if.s_axi_arvalid = 0;
        wait(axi_if.s_axi_rvalid == 1);
        @(posedge clk);
        axi_if.s_axi_rready = 0;

    end

    // initial begin
    //     $display("\t\tStarting the initial begin");
    //     clk_if.set_active();
    //     $display("\t\tClock is activated");
    //     // uvm_config_db#(virtual clk_rst_if  ) :: set(null,"*","clk_if",clk_if);
    //     // uvm_config_db#(virtual axi_intf ) :: set(null,"*","axi_if",axi_if); 
    //     $display("\t\tAll interfaces have been set");
    //     run_test("base_test");
    // end

    // DUT instantiation
    axi_gpio #(
        //System Parameter
        .C_FAMILY                   (       "virtex7"),
        // AXI Parameters
        .C_S_AXI_ADDR_WIDTH         (               9),
        .C_S_AXI_DATA_WIDTH         (              32),
        // GPIO Parameter    
        .C_GPIO_WIDTH               (              32),
        .C_GPIO2_WIDTH              (              32),
        .C_ALL_INPUTS               (               0), 
        .C_ALL_INPUTS_2             (               0),

        .C_ALL_OUTPUTS              (               0), 
        .C_ALL_OUTPUTS_2            (               0),

        .C_INTERRUPT_PRESENT 	    (               0),
        .C_DOUT_DEFAULT             (    32'h00000000),
        .C_TRI_DEFAULT              (    32'hFFFFFFFF),
        .C_IS_DUAL                  (               0),
        .C_DOUT_DEFAULT_2           (    32'h00000000),
        .C_TRI_DEFAULT_2            (    32'hFFFFFFFF)
    ) DUT (
        // AXI interface Signals --------------------------------------------------
        .s_axi_aclk                 (                   clk),
        .s_axi_aresetn              (                 reset),
        .s_axi_awaddr               (   axi_if.s_axi_awaddr),
        .s_axi_awvalid              (  axi_if.s_axi_awvalid),
        .s_axi_awready              (  axi_if.s_axi_awready),
        
        .s_axi_wdata                (    axi_if.s_axi_wdata),
        .s_axi_wstrb                (    axi_if.s_axi_wstrb),
        .s_axi_wvalid               (   axi_if.s_axi_wvalid),
        .s_axi_wready               (   axi_if.s_axi_wready),

        .s_axi_bresp                (    axi_if.s_axi_bresp),
        .s_axi_bvalid               (   axi_if.s_axi_bvalid),
        .s_axi_bready               (   axi_if.s_axi_bready),
        
        .s_axi_araddr               (   axi_if.s_axi_araddr),
        .s_axi_arvalid              (  axi_if.s_axi_arvalid),
        .s_axi_arready              (  axi_if.s_axi_arready),
        
        .s_axi_rdata                (    axi_if.s_axi_rdata),
        .s_axi_rresp                (    axi_if.s_axi_rresp),
        .s_axi_rvalid               (   axi_if.s_axi_rvalid),
        .s_axi_rready               (   axi_if.s_axi_rready),
        
        // Interrupt---------------------------------------------------------------
        .ip2intc_irpt               (  gpio_if.ip2intc_irpt),

        // GPIO Signals------------------------------------------------------------
        .gpio_io_i                  (     gpio_if.gpio_io_i),
        .gpio_io_o                  (     gpio_if.gpio_io_o),
        .gpio_io_t                  (     gpio_if.gpio_io_t),
        .gpio2_io_i                 (    gpio_if.gpio2_io_i),
        .gpio2_io_o                 (    gpio_if.gpio2_io_o),
        .gpio2_io_t                 (    gpio_if.gpio2_io_t)
    );
endmodule