package fifo_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import fifo_sequence_pkg::*;
import fifo_env_pkg::*;
import fifo_config_pkg::*;

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test);
        reset sq1;
        main  sq2;
        fifo_env env;
        fifo_config cfg;

        function new(string name = "fifo_test", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);        
            super.build_phase(phase);
            sq1=reset::type_id::create("rst_n");
            sq2=main::type_id::create("sequences");
            env=fifo_env::type_id::create("env",this);
            cfg=fifo_config::type_id::create("config");

            if(! uvm_config_db #(virtual fifo_if)::get(this,"","virtualIf",cfg.vif))
                `uvm_fatal("build_phase","cant get virtual interface");

            uvm_config_db #(fifo_config)::set(this,"*","CFG",cfg);
        endfunction

        task run_phase(uvm_phase phase);        
            super.build_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","reset sequence has started now",UVM_MEDIUM);
            sq1.start(env.agt.sqr);
            `uvm_info("run_phase","main sequence has started now",UVM_MEDIUM);
            sq2.start(env.agt.sqr);
            phase.drop_objection(this);
        endtask
        

    endclass

endpackage