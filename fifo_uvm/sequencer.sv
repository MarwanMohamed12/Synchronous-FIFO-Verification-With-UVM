package fifo_sequencer_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;
    class fifo_sequencer extends uvm_sequencer #(seq_item);
        `uvm_component_utils(fifo_sequencer);

        function new(string name="sequencer",uvm_component phase);
            super.new(name,phase);
        endfunction
    endclass


endpackage