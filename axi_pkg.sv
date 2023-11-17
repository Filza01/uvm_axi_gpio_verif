package axi_pkg;

  import uvm_pkg::*;
 `include "uvm_macros.svh"

 `include "axi_seq_item.sv"
 `include "axi_seqs.sv"

 `include "wr_sequencer.sv"
 `include "wr_driver.sv"
 `include "wr_monitor.sv"
 `include "wr_agent.sv"

 `include "rd_sequencer.sv"
 `include "rd_driver.sv"
 `include "rd_monitor.sv"
 `include "rd_agent.sv"

 `include "axi_env.sv"
 `include "base_test.sv"
endpackage