onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+axi_gpio_0 -L axi_lite_ipif_v3_0_4 -L lib_cdc_v1_0_2 -L interrupt_control_v3_1_4 -L axi_gpio_v2_0_23 -L xil_defaultlib -L secureip -O5 xil_defaultlib.axi_gpio_0

do {wave.do}

view wave
view structure

do {axi_gpio_0.udo}

run -all

endsim

quit -force
