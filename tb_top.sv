import uvm_pkg::*;
`include "uvm_macros.svh"

parameter C_S_AXI_ADDR_WIDTH = 9;
parameter C_S_AXI_DATA_WIDTH = 32;
parameter C_GPIO_WIDTH = 32;
parameter C_GPIO2_WIDTH = 32;

`include "axi_intf.sv"
`include "gpio_intf.sv"
`include "dv_macros.svh"
`include "clk_rst_if.sv"

`include "axi_env/axi_seq_item.sv"
`include "axi_env/axi_seqs.sv"

`include "axi_env/write_agent/wr_sequencer.sv"
`include "axi_env/write_agent/wr_driver.sv"
`include "axi_env/write_agent/wr_monitor.sv"
`include "axi_env/write_agent/wr_agent.sv"

`include "axi_env/read_agent/rd_sequencer.sv"
`include "axi_env/read_agent/rd_driver.sv"
`include "axi_env/read_agent/rd_monitor.sv"
`include "axi_env/read_agent/rd_agent.sv"

`include "axi_env/axi_env.sv"

`include "gpio_env/gpio_seq_item.sv"
`include "gpio_env/gpio_seqs.sv"
`include "gpio_env/gpio_sequencer.sv"
`include "gpio_env/gpio_driver.sv"
`include "gpio_env/gpio_monitor.sv"
`include "gpio_env/gpio_agent.sv"
`include "gpio_env/gpio_env.sv"

`include "scoreboard.sv"

`include "test_lib.sv"


module tb_top();

    wire clk, reset;

    clk_rst_if clk_if (
        .clk(clk),
        .rst_n(reset)
    );

    axi_intf axi_if (
        .clk(clk)
    );

    gpio_intf gpio_if (
        .clk(clk)
    );

    // initial begin
    //     $dumpfile("waveform.vcd");
    //     $dumpvars();
    // end

    initial begin
        $display("\t\tStarting the initial begin");
        clk_if.set_active();
        $display("\t\tClock is activated");
        uvm_config_db#(virtual clk_rst_if  )::set(null,"*","clk_if",clk_if);
        uvm_config_db#(virtual axi_intf )::set(null,"*","axi_if",axi_if); 
        uvm_config_db#(virtual gpio_intf )::set(null,"*","gpio_if",gpio_if); 
        $display("\t\tAll interfaces have been set");
        run_test("GPIO_channel_1_2_output");
    end

    // DUT instantiation
    axi_gpio_0 DUT (
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
        .ip2intc_irpt              (  gpio_if.ip2intc_irpt),

        // GPIO Signals------------------------------------------------------------
        .gpio_io_i                 (     gpio_if.gpio_io_i),
        .gpio_io_o                 (     gpio_if.gpio_io_o),
        .gpio_io_t                 (     gpio_if.gpio_io_t),
        .gpio2_io_i                (    gpio_if.gpio2_io_i),
        .gpio2_io_o                (    gpio_if.gpio2_io_o),
        .gpio2_io_t                (    gpio_if.gpio2_io_t)
    );
endmodule