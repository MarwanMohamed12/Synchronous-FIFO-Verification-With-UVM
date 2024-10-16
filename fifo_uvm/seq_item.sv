package fifo_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class seq_item extends uvm_sequence_item ;
        `uvm_object_utils(seq_item);
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic  rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
            
        localparam max_fifo_addr = $clog2(FIFO_DEPTH);

        int RD_EN_ON_DIST,WR_EN_ON_DIST;

        function new(string name = "fifo_sequence_item",int RD_EN_ON_DIST_t=30 , int WR_EN_ON_DIST_t=70);
            super.new(name);
            RD_EN_ON_DIST=RD_EN_ON_DIST_t;
            WR_EN_ON_DIST=WR_EN_ON_DIST_t;
        endfunction

         function string convert2string();
            return $sformatf("%s  reset =%0b data_in=%0b ,wr_en=%0b ,rd_en=%0b ,data_out=%0b ,wr_ack=%0b,overflow=%0b ,full=%0b ,empty=%0b
            ,almostfull=%0b,almostempty=%0b ,underflow=%0b ",
            super.convert2string(),rst_n,data_in,wr_en,rd_en,data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("%s  reset =%0b data_in=%0b ,wr_en=%0b ,rd_en=%0b  ",
            super.convert2string(),rst_n,data_in,wr_en,rd_en);
        endfunction

        constraint x{
            rst_n dist { 0:= 5 , 1:= 95 };
            wr_en dist { 1:= WR_EN_ON_DIST , 0:= 100-WR_EN_ON_DIST};
            rd_en dist { 1:= RD_EN_ON_DIST , 0:= 100-RD_EN_ON_DIST};
        }
    

    endclass
endpackage
