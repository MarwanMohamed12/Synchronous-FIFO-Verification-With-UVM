package fifo_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
import shared_pkg::*;

    class reset extends uvm_sequence #(seq_item);
        `uvm_object_utils(reset);
        seq_item item;
        function new(string name = "RESET");
            super.new(name);
        endfunction
        task body();
                item=seq_item::type_id::create("res") ; 
                start_item(item);
                item.rst_n=0;
                finish_item(item);
        endtask
    endclass

    class main extends uvm_sequence #(seq_item);
        `uvm_object_utils(main);
        seq_item item;
        function new(string name = "MAIN");
            super.new(name);
        endfunction

        task body();
            repeat(1000)begin
                item=new("same",50,50); 
                start_item(item);
                assert(item.randomize());
                finish_item(item);
            end
        endtask
    endclass

endpackage
