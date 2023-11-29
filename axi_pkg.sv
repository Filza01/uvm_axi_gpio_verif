package axi_pkg;
parameter C_S_AXI_ADDR_WIDTH = 9;
parameter C_S_AXI_DATA_WIDTH = 32;
  import uvm_pkg::*;
 `include "uvm_macros.svh"

 `include "env_axi/axi_seq_item.sv"
 `include "env_axi/axi_seqs.sv"

 `include "env_axi/write_agent/wr_sequencer.sv"
 `include "env_axi/write_agent/wr_driver.sv"
 `include "env_axi/write_agent/wr_monitor.sv"
 `include "env_axi/write_agent/wr_agent.sv"

 `include "env_axi/read_agent/rd_sequencer.sv"
 `include "env_axi/read_agent/rd_driver.sv"
 `include "env_axi/read_agent/rd_monitor.sv"
 `include "env_axi/read_agent/rd_agent.sv"

 `include "env_axi/multi_sequencer.sv"

 `include "env_axi/axi_env.sv"
//  `include "base_test.sv"
endpackage