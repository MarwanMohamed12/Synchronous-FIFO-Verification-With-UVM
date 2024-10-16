package fifo_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import fifo_sequence_pkg::*;
import fifo_env_pkg::*;
import fifo_config_pkg::*;

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test);
        reset rst_seq;
        write_sequence  write_seq;
        read_sequence read_seq;
        write_read  write_read_seq;
        fifo_env env;
        fifo_config cfg;

        function new(string name = "fifo_test", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);        
            super.build_phase(phase);
            rst_seq=reset::type_id::create("rst_n");
            write_seq=write_sequence::type_id::create("write_sequences");
            read_seq=read_sequence::type_id::create("read_seq");
            write_read_seq=write_read::type_id::create("write_read");
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
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","write sequence has started now",UVM_MEDIUM);
            write_seq.start(env.agt.sqr);
            `uvm_info("run_phase","read sequence has started now",UVM_MEDIUM);
            read_seq.start(env.agt.sqr);
            `uvm_info("run_phase","write and read sequence has started now",UVM_MEDIUM);
            write_read_seq.start(env.agt.sqr);
            `uvm_info("run_phase","reset sequence has started again",UVM_MEDIUM);
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","write and read sequence has started again for second time",UVM_MEDIUM);
            write_read_seq.start(env.agt.sqr);
            phase.drop_objection(this);
        endtask
        

    endclass

endpackage