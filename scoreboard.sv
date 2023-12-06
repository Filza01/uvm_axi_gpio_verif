`uvm_analysis_imp_decl(_gpio)
`uvm_analysis_imp_decl(_axi_wr)
`uvm_analysis_imp_decl(_axi_rd)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp_gpio #(gpio_seq_item, scoreboard) gpio;
    uvm_analysis_imp_axi_wr #(axi_seq_item, scoreboard) axi_wr;
    uvm_analysis_imp_axi_rd #(axi_seq_item, scoreboard) axi_rd;

    int gpio_pkts;
    int axi_wr_pkts;
    int axi_rd_pkts;
    int matched_pkts;
    int mismatched_pkts;

    gpio_seq_item gpio_pkt;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        gpio = new("gpio", this);
        axi_wr = new("axi_wr", this);
        axi_rd = new("axi_rd", this);
    endfunction

    function void write_gpio (gpio_seq_item gpio_seq);
        gpio_pkt = gpio_seq;
        gpio_pkts++;
    endfunction

    function void write_axi_wr (axi_seq_item axi_pkt);
        if (axi_pkt.s_axi_awaddr == 4) begin
            if (axi_pkt.s_axi_wdata != gpio_pkt.gpio_io_t) begin
                `uvm_error(get_full_name(), $sformatf("GPIO channel 1 write PIN Direction mismatch Assigned %b, Received %b", axi_pkt.s_axi_wdata, gpio_pkt.gpio_io_t))
                mismatched_pkts++;
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 1 PINS WRITE DIRECTION TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
        end  

        if (axi_pkt.s_axi_awaddr == 0) begin
            if (axi_pkt.s_axi_wdata != gpio_pkt.gpio_io_o) begin
                `uvm_error(get_full_name(), $sformatf("GPIO channel 1 write pins mismatch Assigned %b, Received %b", axi_pkt.s_axi_wdata, gpio_pkt.gpio_io_o))
                mismatched_pkts++;
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 1 PINS WRITE DATA TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
        end

        if (axi_pkt.s_axi_awaddr == 9'hc) begin
            if (axi_pkt.s_axi_wdata != gpio_pkt.gpio2_io_t) begin
                `uvm_error(get_full_name(), $sformatf("GPIO channel 2 write PIN Direction mismatch Assigned %b, Received %b", axi_pkt.s_axi_wdata, gpio_pkt.gpio2_io_t))
                mismatched_pkts++;
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 2 PINS WRITE DIRECTION TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
        end  

        if (axi_pkt.s_axi_awaddr == 8) begin
            if (axi_pkt.s_axi_wdata != gpio_pkt.gpio2_io_o) begin
                `uvm_error(get_full_name(), $sformatf("GPIO channel 2 write pins mismatch Assigned %b, Received %b", axi_pkt.s_axi_wdata, gpio_pkt.gpio2_io_o))
                mismatched_pkts++;
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 2 PINS WRITE DATA TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
        end

        if (axi_pkt.s_axi_awaddr == 9'h11c) begin
            if (axi_pkt.s_axi_wdata == 32'h80000000) begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO GLOBAL INTERRUPT SET CORRECTLY. TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
            else begin
                `uvm_error(get_full_name(), "GPIO global interrupt not assigned correctly")
                mismatched_pkts++;
            end
        end

        if (axi_pkt.s_axi_awaddr == 9'h128) begin
            if (axi_pkt.s_axi_wdata == 32'h1 || axi_pkt.s_axi_wdata == 32'h2 || axi_pkt.s_axi_wdata == 32'h3) begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO INTERRUPT ENABLE SET CORRECTLY. TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
            else begin
                `uvm_error(get_full_name(), "GPIO interrupt enable not set correctly")
                mismatched_pkts++;
            end
        end

        if (axi_pkt.s_axi_awaddr == 9'h120) begin
            if (axi_pkt.s_axi_wdata == 32'h1 || axi_pkt.s_axi_wdata == 32'h2 || axi_pkt.s_axi_wdata == 32'h3) begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO INTERRUPT STATUS SET CORRECTLY. TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
            else begin
                `uvm_error(get_full_name(), "GPIO interrupt status not set correctly")
                mismatched_pkts++;
            end
        end
        
        axi_wr_pkts++;
    endfunction

    function void write_axi_rd (axi_seq_item axi_pkt);
        if (axi_pkt.s_axi_araddr == 4) begin
            if (axi_pkt.s_axi_rdata != gpio_pkt.gpio_io_t) begin
                `uvm_error(get_full_name(), $sformatf("GPIO channel 1 read PIN Direction mismatch Assigned %b, Received %b", axi_pkt.s_axi_rdata, gpio_pkt.gpio_io_t))
                mismatched_pkts++;
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 1 PINS READ DIRECTION TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
        end
        
        if (axi_pkt.s_axi_araddr == 0) begin
            int match;
            int mismatch;
            foreach(gpio_pkt.gpio_io_t[i]) begin
                if (gpio_pkt.gpio_io_t[i]==1) begin
                    if (axi_pkt.s_axi_rdata[i] === gpio_pkt.gpio_io_i[i]) begin
                        match++;
                    end
                    else begin
                        mismatch++;
                    end
                end
                else if (gpio_pkt.gpio_io_t[i]==0) begin
                    if (axi_pkt.s_axi_rdata[i] === gpio_pkt.gpio_io_o[i]) begin
                        match++;
                    end
                    else begin
                        mismatch++;
                    end
                end
            end
            if (match == 32) begin
                matched_pkts++;
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 1 PINS READ DATA TEST PASS -----\n", UVM_NONE)
            end
            else begin
                mismatched_pkts++;
                `uvm_error(get_full_name(), $sformatf("GPIO channel 1 Read pins mismatch Assigned %b, Received %b, Mismatched Pins = %d",  gpio_pkt.gpio_io_o, axi_pkt.s_axi_rdata, mismatch))
            end
        end

        if (axi_pkt.s_axi_araddr == 9'hc) begin
            if (axi_pkt.s_axi_rdata != gpio_pkt.gpio2_io_t) begin
                `uvm_error(get_full_name(), $sformatf("GPIO channel 2 read PIN Direction mismatch Assigned %b, Received %b", axi_pkt.s_axi_rdata, gpio_pkt.gpio2_io_t))
                mismatched_pkts++;
            end
            else begin
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 2 PINS READ DIRECTION TEST PASS ----- \n", UVM_NONE)
                matched_pkts++;
            end
        end
        
        if (axi_pkt.s_axi_araddr == 8) begin
            int match;
            int mismatch;
            foreach(gpio_pkt.gpio2_io_t[i]) begin
                if (gpio_pkt.gpio2_io_t[i]==1) begin
                    if (axi_pkt.s_axi_rdata[i] === gpio_pkt.gpio2_io_i[i]) begin
                        match++;
                    end
                    else begin
                        mismatch++;
                    end
                end
                else if (gpio_pkt.gpio2_io_t[i]==0) begin
                    if (axi_pkt.s_axi_rdata[i] === gpio_pkt.gpio2_io_o[i]) begin
                        match++;
                    end
                    else begin
                        mismatch++;
                    end
                end
            end
            if (match == 32) begin
                matched_pkts++;
                `uvm_info(get_full_name(), "\n\n\t\t ----- GPIO CHANNEL 2 PINS READ DATA TEST PASS -----\n", UVM_NONE)
            end
            else begin
                mismatched_pkts++;
                `uvm_error(get_full_name(), $sformatf("GPIO channel 2 Read pins mismatch Assigned %b, Received %b, Mismatched Pins = %d",  gpio_pkt.gpio2_io_o, axi_pkt.s_axi_rdata, mismatch))
            end
        end

        axi_rd_pkts++;
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_full_name(), $sformatf("\n\n---------Packets Recieved--------- \n\t\t axi_wr = %d \n\t\t axi_rd = %d \n\t\t Matched Packets = %d \n\t\t Mismatched Packets = %d \n", axi_wr_pkts, axi_rd_pkts, matched_pkts, mismatched_pkts), UVM_NONE)
    endfunction: report_phase 
    
endclass 