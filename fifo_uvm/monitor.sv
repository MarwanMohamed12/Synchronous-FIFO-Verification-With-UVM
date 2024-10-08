package fifo_monitor_pkg;

import uvm_pkg::*;
    `include "uvm_macros.svh"
import fifo_seq_item_pkg::*;

class  fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor);
    virtual fifo_if vif;
    seq_item item;
    uvm_analysis_port #(seq_item) mon_p;

    function new(string name ="fifo monitor", uvm_component parent=null);
        super.new(name,parent);
        mon_p=new("monitor porrt",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin 
            item=seq_item::type_id::create("monitor item") ;
            @(negedge vif.clk);
            item.data_in=vif.data_in;
            item.rst_n =vif.rst_n;
            item.wr_en =vif.wr_en;
            item.rd_en =vif.rd_en;
            // OUTPUT
            item.data_out   =vif.data_out    ;
            item.wr_ack     =vif.wr_ack   ;
            item.overflow   =vif.overflow   ;
            item.full       =vif.full   ;
            item.empty      =vif.empty    ;
            item.almostfull =vif.almostfull   ;
            item.almostempty=vif.almostempty   ;
            item.underflow  =vif.underflow   ;
            mon_p.write(item);
            `uvm_info("run_phase",item.convert2string(),UVM_HIGH);
        end
    endtask
endclass


endpackage