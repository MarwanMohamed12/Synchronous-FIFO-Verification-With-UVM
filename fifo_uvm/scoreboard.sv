package fifo_scoreboard_pkg;

import uvm_pkg::*;
    `include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
import shared_pkg::*;
class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard);

    uvm_tlm_analysis_fifo #(seq_item) sb_fifo;
    uvm_analysis_export #(seq_item) sb_ep;
    seq_item seq_item_tb;
    logic [seq_item::FIFO_WIDTH-1:0] data_out_ref;
    bit [seq_item::FIFO_WIDTH-1 :0] fifo_modeling[$];;

    function new(string name ="fifo_scorebored", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_fifo=new("sb_fifo",this);
        sb_ep=new("sb_ep",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_ep.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_tb);
            reference_model(seq_item_tb);
            if(data_out_ref != seq_item_tb.data_out )begin
            `uvm_error("run_phase",$sformatf("failed check stimulus %s while ref out=%0b",seq_item_tb.convert2string,data_out_ref));
            error_count++;
            end
            else correct_count++;

        end    
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("total passed casses = %0d and total Failed casses  =%0d",correct_count,error_count),UVM_MEDIUM);
    endfunction

    
function void reference_model(input seq_item FI_tr);
    if(!FI_tr.rst_n )begin
        fifo_modeling.delete();
    end
    else begin
        if(FI_tr.wr_en && FI_tr.rd_en && fifo_modeling.size() == 0)begin
            fifo_modeling.push_back(FI_tr.data_in);
        end
        else if(FI_tr.wr_en && FI_tr.rd_en && fifo_modeling.size() == seq_item_tb.FIFO_DEPTH)begin
            data_out_ref=fifo_modeling.pop_front();
        end
        else if(FI_tr.wr_en && FI_tr.rd_en)begin
            fifo_modeling.push_back(FI_tr.data_in);
            data_out_ref=fifo_modeling.pop_front();
        end
        else if(FI_tr.wr_en && fifo_modeling.size() != seq_item_tb.FIFO_DEPTH)begin
            fifo_modeling.push_back(FI_tr.data_in);
        end
        else if(FI_tr.rd_en && fifo_modeling.size() != 0)begin
            data_out_ref=fifo_modeling.pop_front();
        end
    end
endfunction

endclass


endpackage