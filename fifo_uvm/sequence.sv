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

    class write_sequence extends uvm_sequence #(seq_item);
        `uvm_object_utils(write_sequence);
        seq_item item;
        function new(string name = "MAIN");
            super.new(name);
        endfunction

        task body();
            repeat(10)begin
                item=new("writing",50,50); 
                start_item(item);
                assert(item.randomize() with { rst_n==1;rd_en==0;wr_en==1; });
                finish_item(item);
            end
        endtask
    endclass

    class read_sequence extends uvm_sequence #(seq_item);
        `uvm_object_utils(read_sequence);
        seq_item item;
        function new(string name = "MAIN");
            super.new(name);
        endfunction

        task body();
            repeat(10)begin
                item=new("reading"); 
                start_item(item);
                assert(item.randomize() with { rst_n==1;rd_en==1;wr_en==0;});
                finish_item(item);
            end
        endtask
    endclass

    class write_read extends uvm_sequence #(seq_item);
        `uvm_object_utils(write_read);
        seq_item item;
        function new(string name = "MAIN");
            super.new(name);
        endfunction

        task body();
            repeat(500)begin
                item=new("same",50,50); 
                start_item(item);
                assert(item.randomize() with {rst_n==1;});
                finish_item(item);
            end
        endtask
    endclass

endpackage
