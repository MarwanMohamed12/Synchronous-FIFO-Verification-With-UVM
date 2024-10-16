package fifo_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
    import fifo_coverage_pkg::*;
    import fifo_scoreboard_pkg::*;
    import fifo_agent_pkg::*;

    class fifo_env extends uvm_component ;
        `uvm_component_utils(fifo_env);
        fifo_agent agt;
        fifo_cov cov;
        fifo_scoreboard sb;

        function new(string name = "fifo_env", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);        
            super.build_phase(phase);
            sb=fifo_scoreboard::type_id::create("scoreboard",this);
            cov=fifo_cov::type_id::create("coverage collector",this);
            agt=fifo_agent::type_id::create("Agent",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_p.connect(sb.sb_ep);
            agt.agt_p.connect(cov.cov_ep);
        endfunction
    endclass
endpackage
