// import mem_model_pkg::*;
class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    //memory_instance
    // mem_model   memory_instance;

    virtual clk_rst_if clk_if;

    virtual axi_intf axi_if;

    // multi_seq seq_inst;
    axi_write_seq axi_wr;
    axi_read_seq axi_rd;
     
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

        //  memory_instance = mem_model_pkg::mem_model#()::type_id::create("memory_instance", this);

        //  seq_inst = multi_seq::type_id::create("seq_inst",this);
        axi_wr = axi_write_seq::type_id::create("axi_wr",this);
        axi_rd = axi_read_seq::type_id::create("axi_rd",this);
         env_instance = axi_env::type_id::create("env_instance",this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_NONE)

        clk_if.apply_reset(.reset_width_clks (10));

        axi_wr.start(env_instance.write_agent.seqr);
        axi_rd.start(env_instance.read_agent.sequencer);
        ins_if.clk_pos(5); 

        phase.drop_objection(this);
        `uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_NONE)
    endtask: run_phase
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        $display("------------------------- Topology Report -------------------------");
        uvm_top.print_topology();
    endfunction: end_of_elaboration_phase

endclass