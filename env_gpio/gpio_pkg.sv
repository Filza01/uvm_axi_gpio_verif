package gpio_pkg;

    import uvm_pkg::*;
   `include "uvm_macros.svh"
  
   `include "gpio_seq_item.sv"
   `include "gpio_seqs.sv"
  
   `include "gpio_sequencer.sv"
   `include "gpio_driver.sv"
   `include "gpio_monitor.sv"
   `include "gpio_agent.sv"
  
   `include "axi_env.sv"
//    `include "base_test.sv"
  endpackage