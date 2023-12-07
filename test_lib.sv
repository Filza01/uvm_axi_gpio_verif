class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    virtual clk_rst_if clk_if;

    virtual axi_intf axi_if;

    virtual gpio_intf gpio_if;
    
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

class GPIO_ch_1_all_input extends base_test;
    `uvm_component_utils(GPIO_ch_1_all_input)

    axi_write_tir_1_in axi_wr_1;
    axi_read_data_1 axi_rd_1;
    gpio_seq gpio_i;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_in::type_id::create("axi_wr_1",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // set direction of channel 1 pins as input
        axi_wr_1.start(env_axi.write_agent.seqr);
        // executing gpio sequence
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // reading from channel 1 pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase  
endclass

class GPIO_ch_1_all_output extends base_test;
    `uvm_component_utils(GPIO_ch_1_all_output)

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
        // setting direction of channel 1 pins as output
        axi_wr_1.start(env_axi.write_agent.seqr);
        // writing data to output pins
        axi_wr_2.start(env_axi.write_agent.seqr);
        // reading from channel 1 pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase 
endclass

class GPIO_ch_2_all_input extends base_test;
    `uvm_component_utils(GPIO_ch_2_all_input)

    axi_write_tir_2_in axi_wr_1;
    axi_read_data_2 axi_rd_1;
    gpio_seq gpio_i;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_2_in::type_id::create("axi_wr_1",this);
        axi_rd_1 = axi_read_data_2::type_id::create("axi_rd_1",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // setting direction of channel 2 pins as input
        axi_wr_1.start(env_axi.write_agent.seqr);
        // executing gpio sequence
        gpio_i.in2 = 32'h22222222;
        gpio_i.in1 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // reading from the channel pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_ch_2_all_output extends base_test;
    `uvm_component_utils(GPIO_ch_2_all_output)

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
        // setting direction of channel 2 pins as output
        axi_wr_1.start(env_axi.write_agent.seqr);
        // writing data to pins
        axi_wr_2.start(env_axi.write_agent.seqr);
        // reading from channel 2 pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_ch_1_2_input extends base_test;
    `uvm_component_utils(GPIO_ch_1_2_input)

    axi_write_tir_1_in axi_wr_1;
    axi_write_tir_2_in axi_wr_2;
    axi_read_data_1 axi_rd_1;
    axi_read_data_2 axi_rd_2;
    gpio_seq gpio_i;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_in::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_tir_2_in::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // setting direction of channel 1 as input
        axi_wr_1.start(env_axi.write_agent.seqr);
        // setting direction of channel 2 as input
        axi_wr_2.start(env_axi.write_agent.seqr);
        // executing gpio sequence
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h55555555;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // reading from channel 1 pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        // reading from channel 2 pins
        axi_rd_2.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_ch_1_2_output extends base_test;
    `uvm_component_utils(GPIO_ch_1_2_output)

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
        // setting direction of channel 2 as output
        axi_wr_1.start(env_axi.write_agent.seqr);
        // writing data to channel 1 pins
        axi_wr_2.start(env_axi.write_agent.seqr);
        // setting direction of channel 1 as output
        axi_wr_3.start(env_axi.write_agent.seqr);
        // writing data to channel 2 pins
        axi_wr_4.start(env_axi.write_agent.seqr);
        // reading from channel 1 pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        // reading from channel 2 pins
        axi_rd_2.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_ch_1_input_2_output extends base_test;
    `uvm_component_utils(GPIO_ch_1_input_2_output)

    axi_write_tir_1_in axi_wr_1;
    axi_write_data_1 axi_wr_2;
    gpio_seq gpio_i;
    axi_read_data_1 axi_rd_1;
    axi_write_tir_2_out axi_wr_3;
    axi_write_data_2 axi_wr_4;
    axi_read_data_2 axi_rd_2;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_in::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_data_1::type_id::create("axi_wr_2",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_wr_3 = axi_write_tir_2_out::type_id::create("axi_wr_3",this);
        axi_wr_4 = axi_write_data_2::type_id::create("axi_wr_4",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // setting direction of channel 1 as input
        axi_wr_1.start(env_axi.write_agent.seqr);
        // writing data to channel 1 pins
        axi_wr_2.start(env_axi.write_agent.seqr);
        // setting direction of channel 2 as output
        axi_wr_3.start(env_axi.write_agent.seqr);
        // writing data to channel 2 pins
        axi_wr_4.start(env_axi.write_agent.seqr);
        // executing gpio sequence
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h22222222;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // reading from chanel 1 pins
        axi_rd_1.start(env_axi.read_agent.sequencer);
        // reading from chanel 2 pins
        axi_rd_2.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_ch_1_output_2_input extends base_test;
    `uvm_component_utils(GPIO_ch_1_output_2_input)

    axi_write_tir_1_out axi_wr_1;
    axi_write_data_1 axi_wr_2;
    gpio_seq gpio_i;
    axi_read_data_1 axi_rd_1;
    axi_write_tir_2_in axi_wr_3;
    axi_write_data_2 axi_wr_4;
    axi_read_data_2 axi_rd_2;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_tir_1_out::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_data_1::type_id::create("axi_wr_2",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_wr_3 = axi_write_tir_2_in::type_id::create("axi_wr_3",this);
        axi_wr_4 = axi_write_data_2::type_id::create("axi_wr_4",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
    endfunction : build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // setting direction of channel 1 as output
        axi_wr_1.start(env_axi.write_agent.seqr);
        // writing data to channel 1
        axi_wr_2.start(env_axi.write_agent.seqr);
        // setting direction of channel 2 as input
        axi_wr_3.start(env_axi.write_agent.seqr);
        // writing data to channel 2
        axi_wr_4.start(env_axi.write_agent.seqr);
        // executing gpio sequence
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h22222222;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // reading from channel 1
        axi_rd_1.start(env_axi.read_agent.sequencer);
        // reading from channel 2
        axi_rd_2.start(env_axi.read_agent.sequencer);
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask: main_phase   
endclass

class GPIO_ch_1_2_intr_en_with_input_at_ch_any extends base_test;
    `uvm_component_utils(GPIO_ch_1_2_intr_en_with_input_at_ch_any)

    axi_write_GIER axi_wr_1;
    axi_write_IPIER_1_2 axi_wr_3;
    axi_write_tir_1_in axi_wr_2;
    axi_write_tir_2_in axi_wr_4;
    gpio_seq gpio_i;
    axi_read_data_1 axi_rd_1;
    axi_read_data_2 axi_rd_2;
    axi_write_IPISR_1 axi_wr_5;
    axi_write_IPISR_2 axi_wr_6;
    axi_write_IPISR_1_2 axi_wr_7;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_GIER::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_tir_1_in::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
        axi_wr_3 = axi_write_IPIER_1_2::type_id::create("axi_wr_3",this);
        axi_wr_4 = axi_write_tir_2_in::type_id::create("axi_wr_4",this);
        axi_wr_5 = axi_write_IPISR_1::type_id::create("axi_wr_5",this);
        axi_wr_6 = axi_write_IPISR_2::type_id::create("axi_wr_6",this);
        axi_wr_7 = axi_write_IPISR_1_2::type_id::create("axi_wr_7",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
    endfunction: build_phase
    
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // enable global interrupt
        axi_wr_1.start(env_axi.write_agent.seqr);
        // enable channel 1 & 2 interrupts
        axi_wr_3.start(env_axi.write_agent.seqr);
        // setting directions of both channels as input
        axi_wr_2.start(env_axi.write_agent.seqr);
        axi_wr_4.start(env_axi.write_agent.seqr);
        // initializing gpio channels
        gpio_i.in1 = 32'h00000000;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);

        interrupt_at_channel_1();

        interrupt_at_channel_2();
        
        interrupt_at_both_channels();
        
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask

    task interrupt_at_channel_1();
        // transition at channel 1
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        wait(gpio_if.ip2intc_irpt);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 DETECTED.-----\n", UVM_NONE)
            // configuring interrupt status register for channel 1
            axi_wr_5.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 NOT DETECTED.-----\n", UVM_NONE)  
        end
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask

    task interrupt_at_channel_2();
        // transition at channel 2
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h23283482;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        wait(gpio_if.ip2intc_irpt);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 DETECTED.-----\n", UVM_NONE)
            // configuring interrupt status register for channel 2
            axi_wr_6.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 NOT DETECTED.-----\n", UVM_NONE)  
        end
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask

    task interrupt_at_both_channels();
        // transition at both channels
        gpio_i.in1 = 32'h83752373;
        gpio_i.in2 = 32'h92374289;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        wait(gpio_if.ip2intc_irpt);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT DETECTED.-----\n", UVM_NONE)
            // configuring interrupt status register for both channels
            axi_wr_7.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT NOT DETECTED.-----\n", UVM_NONE)  
        end
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask
endclass 

class GPIO_ch_1_intr_en_with_input_at_ch_any extends base_test;
    `uvm_component_utils(GPIO_ch_1_intr_en_with_input_at_ch_any)

    axi_write_GIER axi_wr_1;
    axi_write_IPIER_1 axi_wr_3;
    axi_write_tir_1_in axi_wr_2;
    axi_write_tir_2_in axi_wr_4;
    gpio_seq gpio_i;
    axi_read_data_1 axi_rd_1;
    axi_read_data_2 axi_rd_2;
    axi_write_IPISR_1 axi_wr_5;
    axi_write_IPISR_2 axi_wr_6;
    axi_write_IPISR_1_2 axi_wr_7;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_GIER::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_tir_1_in::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
        axi_wr_3 = axi_write_IPIER_1::type_id::create("axi_wr_3",this);
        axi_wr_4 = axi_write_tir_2_in::type_id::create("axi_wr_4",this);
        axi_wr_5 = axi_write_IPISR_1::type_id::create("axi_wr_5",this);
        axi_wr_6 = axi_write_IPISR_2::type_id::create("axi_wr_6",this);
        axi_wr_7 = axi_write_IPISR_1_2::type_id::create("axi_wr_7",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
    endfunction: build_phase
    
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // enable global interrupt
        axi_wr_1.start(env_axi.write_agent.seqr);
        // enable channel 1 interrupt
        axi_wr_3.start(env_axi.write_agent.seqr);
        // setting directions of both channels as input
        axi_wr_2.start(env_axi.write_agent.seqr);
        axi_wr_4.start(env_axi.write_agent.seqr);
        // initializing gpio channels
        gpio_i.in1 = 32'h00000000;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);

        interrupt_at_channel_1();

        interrupt_at_channel_2();
        
        interrupt_at_both_channels();
        
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask

    task interrupt_at_channel_1();
        // transition at channel 1
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        clk_if.wait_clks(10);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 DETECTED. TEST PASSED-----\n", UVM_NONE)
            // configuring interrupt status register for channel 1
            axi_wr_5.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 NOT DETECTED. TEST FAILED-----\n", UVM_NONE)  
        end
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask

    task interrupt_at_channel_2();
        // transition at channel 2
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h23283482;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        clk_if.wait_clks(10);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 DETECTED. TEST PASSED-----\n", UVM_NONE)
            axi_wr_6.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 NOT DETECTED. TEST FAILED-----\n", UVM_NONE)  
        end
        // configuring interrupt status register for channel 2
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask

    task interrupt_at_both_channels();
        // transition at both channels
        gpio_i.in1 = 32'h83752373;
        gpio_i.in2 = 32'h92374289;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        clk_if.wait_clks(10);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT DETECTED. TEST PASSED-----\n", UVM_NONE)
            // configuring interrupt status register for both channels
            axi_wr_7.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT NOT DETECTED. TEST FAILED-----\n", UVM_NONE)  
        end
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask
endclass 

class GPIO_ch_2_intr_en_with_input_at_ch_any extends base_test;
    `uvm_component_utils(GPIO_ch_2_intr_en_with_input_at_ch_any)

    axi_write_GIER axi_wr_1;
    axi_write_IPIER_2 axi_wr_3;
    axi_write_tir_1_in axi_wr_2;
    axi_write_tir_2_in axi_wr_4;
    gpio_seq gpio_i;
    axi_read_data_1 axi_rd_1;
    axi_read_data_2 axi_rd_2;
    axi_write_IPISR_1 axi_wr_5;
    axi_write_IPISR_2 axi_wr_6;
    axi_write_IPISR_1_2 axi_wr_7;

    function new(string name, uvm_component parent);
            super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_1 = axi_write_GIER::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_tir_1_in::type_id::create("axi_wr_2",this);
        axi_rd_1 = axi_read_data_1::type_id::create("axi_rd_1",this);
        axi_rd_2 = axi_read_data_2::type_id::create("axi_rd_2",this);
        axi_wr_3 = axi_write_IPIER_2::type_id::create("axi_wr_3",this);
        axi_wr_4 = axi_write_tir_2_in::type_id::create("axi_wr_4",this);
        axi_wr_5 = axi_write_IPISR_1::type_id::create("axi_wr_5",this);
        axi_wr_6 = axi_write_IPISR_2::type_id::create("axi_wr_6",this);
        axi_wr_7 = axi_write_IPISR_1_2::type_id::create("axi_wr_7",this);
        gpio_i = gpio_seq::type_id::create("gpio_i",this);
    endfunction: build_phase
    
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<main_phase> started, objection raised.", UVM_NONE)
        // enable global interrupt
        axi_wr_1.start(env_axi.write_agent.seqr);
        // enable channel 1 interrupt
        axi_wr_3.start(env_axi.write_agent.seqr);
        // setting directions of both channels as input
        axi_wr_2.start(env_axi.write_agent.seqr);
        axi_wr_4.start(env_axi.write_agent.seqr);
        // initializing gpio channels
        gpio_i.in1 = 32'h00000000;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);

        interrupt_at_channel_1();

        interrupt_at_channel_2();
        
        interrupt_at_both_channels();
        
        clk_if.wait_clks(5);
        phase.drop_objection(this);
        `uvm_info(get_name(), "<main_phase> finished, objection dropped.", UVM_NONE)
    endtask

    task interrupt_at_channel_1();
        // transition at channel 1
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h00000000;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        clk_if.wait_clks(10);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 DETECTED.-----\n", UVM_NONE)
            // configuring interrupt status register for channel 1
            axi_wr_5.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 1 NOT DETECTED.-----\n", UVM_NONE)  
        end
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask

    task interrupt_at_channel_2();
        // transition at channel 2
        gpio_i.in1 = 32'h22222222;
        gpio_i.in2 = 32'h23283482;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        clk_if.wait_clks(10);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 DETECTED-----\n", UVM_NONE)
            axi_wr_6.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT AT CHANNEL 2 NOT DETECTED-----\n", UVM_NONE)  
        end
        // configuring interrupt status register for channel 2
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask

    task interrupt_at_both_channels();
        // transition at both channels
        gpio_i.in1 = 32'h83752373;
        gpio_i.in2 = 32'h92374289;
        gpio_i.start(env_gpio.agent.seqr);
        axi_if.clk_pos(2);
        // waiting for interrupt
        clk_if.wait_clks(10);
        if (gpio_if.ip2intc_irpt == 1) begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT DETECTED.-----\n", UVM_NONE)
            // configuring interrupt status register for both channels
            axi_wr_7.start(env_axi.write_agent.seqr);
            if (gpio_if.ip2intc_irpt === 0 || gpio_if.ip2intc_irpt === 1'bx) begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT HAS BEEN DISABLED. TEST PASSED-----\n", UVM_NONE)
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT COULD NOT BE DISABLED. TEST FAILED-----\n", UVM_NONE)  
            end
        end
        else begin
            `uvm_info(get_full_name(), "\n\n\t\t -----INTERRUPT NOT DETECTED.-----\n", UVM_NONE)  
        end
        
        // reading values at both channels
        axi_rd_1.start(env_axi.read_agent.sequencer);
        axi_rd_2.start(env_axi.read_agent.sequencer);
    endtask
endclass 