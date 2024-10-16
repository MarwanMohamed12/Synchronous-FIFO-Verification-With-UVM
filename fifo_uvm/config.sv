package fifo_config_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_config extends uvm_object ;
        `uvm_object_utils(fifo_config);
        virtual fifo_if vif;
        function new(string name="config_object");
            super.new(name);
        endfunction
    endclass
endpackage