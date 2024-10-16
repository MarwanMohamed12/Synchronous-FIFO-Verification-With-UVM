package fifo_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_driver_pkg::*;
import fifo_monitor_pkg::*;
import fifo_sequencer_pkg::*;
import fifo_config_pkg::*;
import fifo_seq_item_pkg::*;

    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent);
        fifo_driver drv;
        fifo_sequencer sqr;
        fifo_monitor mon;
        uvm_analysis_port #(seq_item) agt_p;
        fifo_config cfg;

        function new(string name = "shift_reg_agent", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            drv=fifo_driver::type_id::create("driver",this);
            mon=fifo_monitor::type_id::create("monitor",this);
            sqr=fifo_sequencer::type_id::create("sequencer",this);
            agt_p=new("agent analysis port",this);

            if(!uvm_config_db #(fifo_config)::get(this,"*","CFG",cfg))
                `uvm_fatal("build_phase","cant get configuration object");
        endfunction

        function void connect_phase(uvm_phase phase);  
            super.connect_phase(phase);
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_p.connect(agt_p);
            mon.vif=cfg.vif;
            drv.vif=cfg.vif;            
        endfunction
        

    endclass





endpackage