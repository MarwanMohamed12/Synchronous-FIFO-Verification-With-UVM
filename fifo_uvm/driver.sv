package fifo_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;

    class fifo_driver extends uvm_driver #(seq_item);
        `uvm_component_utils(fifo_driver);
        virtual fifo_if vif;
        seq_item item;

        function new(string name = "shift_reg_driver", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                item=seq_item::type_id::create("item");
                seq_item_port.get_next_item(item);
                vif.data_in=item.data_in;
                vif.rst_n= item.rst_n;
                vif.wr_en=item.wr_en;
                vif.rd_en=item.rd_en;
                @(negedge vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase",item.convert2string(),UVM_HIGH);
            end
        endtask
    endclass
endpackage

