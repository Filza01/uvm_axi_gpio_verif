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

    function bit compare(gpio_intf prev);
        if (gpio_io_t !== prev.gpio_io_t ||
            gpio_io_i !== prev.gpio_io_i ||
            gpio_io_o !== prev.gpio_io_o ||
            gpio2_io_t !== prev.gpio2_io_t ||
            gpio2_io_i !== prev.gpio2_io_i ||
            gpio2_io_o !== prev.gpio2_io_o ||
            ip2intc_irpt !== prev.ip2intc_irpt ) begin
            return 1; // Change detected
        end
        else return 0; // No change
    endfunction

    function void copy(gpio_intf other);
        gpio_io_t = other.gpio_io_t;
        gpio_io_i = other.gpio_io_i;
        gpio_io_o = other.gpio_io_o;
        gpio2_io_t = other.gpio2_io_t;
        gpio2_io_i = other.gpio2_io_i;
        gpio2_io_o = other.gpio2_io_o;
        ip2intc_irpt = other.ip2intc_irpt;
    endfunction
endinterface