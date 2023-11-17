UVM_HOME = ../uvm-src/uvm-1.1d
UVM_VERBOSITY = UVM_MEDIUM
USR_OPT = $(addprefix , $(TEST))
TEST_DIR = /home/user100/VM/uvm_axi_verif

VCS =	vcs -sverilog -timescale=1ns/1ns \
	+acc +vpi -PP \
	+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	-ntb_opts uvm-1.2 \
	-cm line+cond+fsm+branch+tgl -cm_dir ./coverage.vdb \
  	-debug_access+all \
	-CFLAGS -DVCS

SIMV = ./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) \
	+UVM_TESTNAME=$(USR_OPT) +UVM_TR_RECORD +UVM_LOG_RECORD \
	+verbose=1 -l vcs.log

run:	build run 

build:
	$(VCS) +incdir+$(TEST_DIR)/read_agent \
  +incdir+$(TEST_DIR)/write_agent \
  +incdir+$(TEST_DIR)/hdl \
  axi_intf.sv \
  clk_rst_if.sv \
  axi_pkg.sv \
  tb_top.sv \
  
sim:
   ifeq ($(GUI), 1)
	$(SIMV) -gui &
   else
	$(SIMV)
   endif 



clean:
	rm -rf coverage.vdb csrc DVEfiles inter.vpd simv simv.daidir ucli.key vc_hdrs.h vcs.log .inter.vpd.uvm

