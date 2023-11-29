// import mem_model_pkg::*;
class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    virtual clk_rst_if clk_if;

    virtual axi_intf axi_if;

    // multi_seq seq_inst;
    axi_write_seq_tir axi_wr_1;
    axi_read_seq_tri axi_rd_1;
    axi_read_seq_data axi_rd_2;
    axi_write_seq_data axi_wr_2;
     
    //environment instance for test
    axi_env  env_instance;
    
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
        //  seq_inst = multi_seq::type_id::create("seq_inst",this);
        axi_wr_1 = axi_write_seq_tir::type_id::create("axi_wr_1",this);
        axi_wr_2 = axi_write_seq_data::type_id::create("axi_wr_1",this);
        axi_rd_1 = axi_read_seq_tri::type_id::create("axi_rd_1",this);
        axi_rd_2 = axi_read_seq_data::type_id::create("axi_rd_2",this);
        env_instance = axi_env::type_id::create("env_instance",this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_NONE)

        clk_if.apply_reset(.reset_width_clks (10));

        // fork
            axi_wr_1.start(env_instance.write_agent.seqr);
            axi_wr_2.start(env_instance.write_agent.seqr);
            axi_rd_1.start(env_instance.read_agent.sequencer);
            axi_rd_2.start(env_instance.read_agent.sequencer);
        // join
            axi_if.clk_pos(5); 

        phase.drop_objection(this);
        `uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_NONE)
    endtask: run_phase
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        $display("------------------------- Topology Report -------------------------");
        uvm_top.print_topology();
    endfunction: end_of_elaboration_phase
endclass

// class write_test extends base_test;
//     `uvm_component_utils(write_test)

//     function new(string name, uvm_component parent);
//             super.new(name, parent);
//     endfunction : new

//     function void build_phase(uvm_phase phase);
//         uvm_config_wrapper::set(this, "env_instance.write_agent.seqr.run_phase","default_sequence",axi_write_seq::get_type());
//         super.build_phase(phase);
//     endfunction : build_phase
// endclass