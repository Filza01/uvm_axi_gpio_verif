
Verification of AXI GPIO core using UVM. The directed tests approach was opted for this project.

![GPIO-Page-3](https://github.com/Filza01/uvm_axi_gpio_verif/assets/140054781/4dd6c330-d3fe-4ce9-b470-e969d67c858c)


The design under test was as follows:

![GPIO-Page-2](https://github.com/Filza01/uvm_axi_gpio_verif/assets/140054781/2aba8925-6c2a-43a2-9288-a654293b3792)


The goal of this project was to create a UVM based verification environment for Xilinx LogiCORE IP AXI-GPIO core, which provides a general purpose input/output interface to AXI4-Lite interface. Two environments were created, one for AXI4-Lite interface and other for GPIO interface. The two of them were integrated together in the base test. Different test cases were designed in which sequences for both environments were run to achieve the desired result for that test case.

![GPIO](https://github.com/Filza01/uvm_axi_gpio_verif/assets/140054781/0edf2254-2851-4201-95d9-b0e5444a335e)
