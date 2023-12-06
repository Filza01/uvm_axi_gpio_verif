class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    virtual clk_rst_if clk_if;

    virtual axi_intf axi_if;

    virtual gpio_intf gpio_if;
     
    //environment instance for test
    axi_env  env_axi;
    gpio_env env_gpio;

    uvm_objection obj;

    scoreboard scb;
    
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
       if(!uvm_config_db #(virtual axi_intf)::get(this, "", "axi_if", axi_if)) begin
         `uvm_fatal("base_test", "base_test::Failed to get axi_if")
        end

        if(!uvm_config_db #(virtual clk_rst_if )::get(null, "*", "clk_if", clk_if)) begin
          `uvm_fatal("base_test", "base_test::Failed to get clk_if")
        end

        if(!uvm_config_db #(virtual gpio_intf)::get(this, "", "gpio_if", gpio_if)) begin
            `uvm_fatal("base_test", "base_test::Failed to get gpio_if")
        end
        env_axi = axi_env::type_id::create("env_axi",this);
        env_gpio = gpio_env::type_id::create("env_gpio",this);
        obj = uvm_objection::type_id::create("obj", this);
        scb = scoreboard::type_id::create("scb",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        env_axi.write_agent.mon.write_port.connect(scb.axi_wr);
        env_axi.read_agent.monitor.read_port.connect(scb.axi_rd);
        env_gpio.agent.mon.gpio_port.connect(scb.gpio);
    endfunction: connect_phase
    
    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<reset_phase> started, objection raised.", UVM_NONE)   
        clk_if.apply_reset(.reset_width_clks (10));    
        phase.drop_objection(this);
        `uvm_info(get_name(), "<reset_phase> finished, objection dropped.", UVM_NONE)
    endtask: reset_phase 

    task pre_main_phase(uvm_phase phase);
        obj.raise_objection(this);
        `uvm_info(get_full_name(), "<pre_main_phase> started, objection raised.", UVM_NONE)
    endtask: pre_main_phase

    task post_main_phase(uvm_phase phase);
        obj.drop_objection(this);
        `uvm_info(get_name(), "<post_main_phase> finished, objection dropped.", UVM_NONE)
    endtask: post_main_phase
    
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        $display("------------------------- Topology Report -------------------------");
        uvm_top.print_topology();
    endfunction: end_of_elaboration_phase
endclass

class GPIO_channel_1_all_input extends base_test;
    `uvm_component_utils(GPIO_channel_1_all_input)

    axi_write_tir_1_in axi_wr_1;
    axi_read_data_1 axi_rd_1;
    gpio_seq_channel_1_in gpio_i;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_in::type_id::create("axi_wr_1",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        gpio_i = gpio_seq_channel_1_in::type_id::create("gpio_i",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        axi_wr_1.start(env_axi.write_agent.seqr);
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_if.clk_pos(2);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase  
endclass

class GPIO_channel_1_all_output extends base_test;
    `uvm_component_utils(GPIO_channel_1_all_output)

    axi_write_tir_1_out axi_wr_1;
    axi_write_data_1 axi_wr_2;
    axi_read_data_1 axi_rd_1;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_out::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_data_1::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        axi_wr_1.start(env_axi.write_agent.seqr);
        axi_wr_2.start(env_axi.write_agent.seqr);
        axi_rd_1.start(env_axi.read_agent.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase 
endclass

class GPIO_channel_2_all_input extends base_test;
    `uvm_component_utils(GPIO_channel_2_all_input)

    axi_write_tir_2_in axi_wr_1;
    axi_read_data_2 axi_rd_1;
    gpio_seq_channel_2_in gpio_i;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_2_in::type_id::create("axi_wr_1",this);
        axi_rd_1 = axi_read_data_2::type_id::create("axi_rd_1",this);
        gpio_i = gpio_seq_channel_2_in::type_id::create("gpio_i",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        axi_wr_1.start(env_axi.write_agent.seqr);
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_if.clk_pos(2);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_channel_2_all_output extends base_test;
    `uvm_component_utils(GPIO_channel_2_all_output)

    axi_write_tir_2_out axi_wr_1;
    axi_write_data_2 axi_wr_2;
    axi_read_data_2 axi_rd_1;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_2_out::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_data_2::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_2::type_id::create("axi_rd_1",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        axi_wr_1.start(env_axi.write_agent.seqr);
        axi_wr_2.start(env_axi.write_agent.seqr);
        axi_rd_1.start(env_axi.read_agent.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_channel_1_2_input extends base_test;
    `uvm_component_utils(GPIO_channel_1_2_input)

    axi_write_tir_1_in axi_wr_1;
    axi_write_tir_2_in axi_wr_2;
    axi_read_data_1 axi_rd_1;
    axi_read_data_2 axi_rd_2;
    gpio_seq_channel_1_in gpio_1_i;
    gpio_seq_channel_2_in gpio_2_i;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_in::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_tir_2_in::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
        gpio_1_i = gpio_seq_channel_1_in::type_id::create("gpio_1_i",this);
        gpio_2_i = gpio_seq_channel_2_in::type_id::create("gpio_2_i",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        axi_wr_1.start(env_axi.write_agent.seqr);
        axi_wr_2.start(env_axi.write_agent.seqr);
        gpio_1_i.start(env_gpio.agent.seqr);
        gpio_2_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
        axi_if.clk_pos(2);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_channel_1_2_output extends base_test;
    `uvm_component_utils(GPIO_channel_1_2_output)

    axi_write_tir_1_out axi_wr_1;
    axi_write_data_1 axi_wr_2;
    axi_read_data_1 axi_rd_1;
    axi_write_tir_2_out axi_wr_3;
    axi_write_data_2 axi_wr_4;
    axi_read_data_2 axi_rd_2;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_out::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_data_1::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_wr_3 = axi_write_tir_2_out::type_id::create("axi_wr_3",this);
        axi_wr_4 = axi_write_data_2::type_id::create("axi_wr_4",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        axi_wr_1.start(env_axi.write_agent.seqr);
        axi_wr_2.start(env_axi.write_agent.seqr);
        axi_wr_3.start(env_axi.write_agent.seqr);
        axi_wr_4.start(env_axi.write_agent.seqr);
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass
