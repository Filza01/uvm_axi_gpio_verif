interface gpio_intf (input clk);
    // Interrupt---------------------------------------------------------------
    logic                       ip2intc_irpt;          

    // GPIO Signals------------------------------------------------------------
    logic [C_GPIO_WIDTH-1:0]    gpio_io_i;               
    logic [C_GPIO_WIDTH-1:0]    gpio_io_o;               
    logic [C_GPIO_WIDTH-1:0]    gpio_io_t;               
    logic [C_GPIO2_WIDTH-1:0]   gpio2_io_i;              
    logic [C_GPIO2_WIDTH-1:0]   gpio2_io_o;              
    logic [C_GPIO2_WIDTH-1:0]   gpio2_io_t;              

    task clk_pos(input int count);
        repeat (count) @(posedge clk);
    endtask

    // driver and monitor clocking blocks 
    clocking cb_driver @(posedge clk);
        default input #1ns output #1ns;
        // Interrupt
        input       ip2intc_irpt;            
        // GPIO Signals
        output      gpio_io_i;               
        input       gpio_io_o;               
        input       gpio_io_t;               
        output      gpio2_io_i;              
        input       gpio2_io_o;              
        input       gpio2_io_t;              

    endclocking

    clocking cb_monitor @(posedge clk);
        default input #1ns output #1ns;
         // Interrupt
        input       ip2intc_irpt;            
        // GPIO Signals
        input       gpio_io_i;               
        input       gpio_io_o;               
        input       gpio_io_t;               
        input       gpio2_io_i;              
        input       gpio2_io_o;              
        input       gpio2_io_t; 
    endclocking

endinterface