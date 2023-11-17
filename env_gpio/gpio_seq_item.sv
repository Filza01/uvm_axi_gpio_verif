class gpio_seq_item extends uvm_sequence_item;
    `uvm_object_utils (gpio_seq_item) //factory registeration
    
    // Interrupt---------------------------------------------------------------
    logic                       ip2intc_irpt;          

    // GPIO Signals------------------------------------------------------------
    logic [C_GPIO_WIDTH-1:0]    gpio_io_i;   // randomize it if want to            
    logic [C_GPIO_WIDTH-1:0]    gpio_io_o;               
    logic [C_GPIO_WIDTH-1:0]    gpio_io_t;               
    logic [C_GPIO2_WIDTH-1:0]   gpio2_io_i;  // randomize it if want to            
    logic [C_GPIO2_WIDTH-1:0]   gpio2_io_o;              
    logic [C_GPIO2_WIDTH-1:0]   gpio2_io_t;
    endclass 