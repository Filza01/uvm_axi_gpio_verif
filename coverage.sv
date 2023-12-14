class write_coverage extends uvm_subscriber #(axi_seq_item);
    `uvm_component_utils(write_coverage)

    axi_seq_item axi_pkt;

    covergroup axi_to_dut;
        addr : coverpoint axi_pkt.s_axi_awaddr {
            bins ch1_tir = {9'h4};
            bins ch1_data = {9'h0};
            bins ch2_tir = {9'hc};
            bins ch2_data = {9'h8};
            bins glbl_intr = {9'h11c};
            bins intr_en = {9'h128};
            bins intr_st = {9'h120};
        }

        data_tir : coverpoint axi_pkt.s_axi_wdata {
            bins all_output = {32'h00000000};
            bins all_input = {32'hffffffff};
        }

        data_glbl_intr : coverpoint axi_pkt.s_axi_wdata {
            bins glbl = {32'h80000000};
        }

        data_intr_en_st : coverpoint axi_pkt.s_axi_wdata {
            bins ch1 = {32'h00000001};
            bins ch2 = {32'h00000002};
            bins ch1_2 = {32'h00000003};
        }

        direction : cross addr, data_tir {
            ignore_bins c1 = binsof(addr.ch1_data);
            ignore_bins c2 = binsof(addr.ch2_data);
            ignore_bins c3 = binsof(addr.glbl_intr);
            ignore_bins c4 = binsof(addr.intr_en);
            ignore_bins c5 = binsof(addr.intr_st);
        }

        glbl_intr : cross addr, data_glbl_intr {
            ignore_bins c1 = binsof(addr.ch1_data);
            ignore_bins c2 = binsof(addr.ch2_data);
            ignore_bins c3 = binsof(addr.ch1_tir);
            ignore_bins c4 = binsof(addr.ch2_tir);
            ignore_bins c5 = binsof(addr.intr_en);
            ignore_bins c6 = binsof(addr.intr_st);
        }

        intr : cross addr, data_intr_en_st {
            ignore_bins c1 = binsof(addr.ch1_data);
            ignore_bins c2 = binsof(addr.ch2_data);
            ignore_bins c3 = binsof(addr.ch1_tir);
            ignore_bins c4 = binsof(addr.ch2_tir);
            ignore_bins c5 = binsof(addr.glbl_intr);
        }

        
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
        axi_to_dut = new();
    endfunction: new

    function void write(axi_seq_item t);
        this.axi_pkt = t;
        axi_to_dut.sample();
    endfunction
endclass 

class read_coverage extends uvm_subscriber #(axi_seq_item);
    `uvm_component_utils(read_coverage)

    axi_seq_item axi_pkt;

    covergroup axi_to_dut;
        addr : coverpoint axi_pkt.s_axi_araddr {
            bins ch1_data = {9'h0};
            bins ch2_data = {9'h8};
        }

        data_data : coverpoint axi_pkt.s_axi_rdata {
            bins ch_data_out = {32'h34343434};
            bins ch_data1_in = {32'h22222222};
            bins ch_data2_in = {32'h44444444};
            bins ch_data3_in = {32'h77777777};
            bins ch_data4_in = {32'h99999999};
        }

        data_1 : cross addr, data_data {
            ignore_bins c1 = binsof(addr.ch2_data);
            ignore_bins c2 = binsof(data_data.ch_data2_in);
            ignore_bins c3 = binsof(data_data.ch_data4_in);
        }

        data_2 : cross addr, data_data {
            ignore_bins c1 = binsof(addr.ch1_data);
            ignore_bins c2 = binsof(data_data.ch_data1_in);
            ignore_bins c3 = binsof(data_data.ch_data3_in);
        }
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
        axi_to_dut = new();
    endfunction: new

    function void write(axi_seq_item t);
        this.axi_pkt = t;
        axi_to_dut.sample();
    endfunction
endclass 