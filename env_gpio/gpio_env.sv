class gpio_env extends uvm_env;
    `uvm_component_utils(gpio_env);

    gpio_agent agent;

    function new(string name = "gpio_env", uvm_component parent = null);
        super.new(name , parent);
    endfunction

    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        agent = gpio_agent::type_id::create("agent",this);
    endfunction

endclass 