package fifo_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;

    class fifo_cov extends uvm_component;
        `uvm_component_utils(fifo_cov);

        seq_item item;
        uvm_tlm_analysis_fifo #(seq_item) cov_fifo;
        uvm_analysis_export  #(seq_item) cov_ep;

        //covergorup
        covergroup check_state ;
            Reset:coverpoint item.rst_n{
                bins low={0};
                bins high={1};
            }
            Writing:coverpoint item.wr_en{
                bins write_disaple={0};
                bins write_enaple={1};
                option.weight=0;
            }
            Reading:coverpoint item.rd_en{
                bins read_disaple={0};
                bins read_enaple={1};
                option.weight=0;
            }
            ack_BIN:coverpoint item.wr_ack {
                bins ack_low={0};
                bins ack_high={1};
                option.weight=0;
            }
            OF_BIN:coverpoint item.overflow {
                bins OF_low={0};
                bins OF_high={1};
                option.weight=0;
            }
            FULL_BIN:coverpoint item.full {
                bins FULL_low={0};
                bins FULL_high={1};
                option.weight=0;
            }          
            EMPTY_BIN:coverpoint item.empty {
                bins EMPTY_low={0};
                bins EMPTY_high={1};
                option.weight=0;
            }
            ALMOSTFULL_BIN:coverpoint item.almostfull {
                bins AF_low={0};
                bins AF_high={1};
                option.weight=0;
            }
            ALMOSTEMPTY_BIN:coverpoint item.almostempty {
                bins AE_low={0};
                bins AE_high={1};
                option.weight=0;
            } 
            UNDERFLOW_BIN:coverpoint item.underflow {
                bins UF_low={0};
                bins UF_high={1};
                option.weight=0;
            }         

            ACKNOWLDGE: cross Writing,Reading,ack_BIN{
                illegal_bins Ack1= binsof(ack_BIN) intersect {1} && binsof(Writing) intersect {0} iff (item.rst_n);
            }
            OVERFLOW:   cross Writing,Reading,OF_BIN{
                illegal_bins OF1= binsof(OF_BIN)  intersect {1} && binsof(Writing) intersect {0};
                illegal_bins OF2= binsof(OF_BIN)  intersect {1} && binsof(Writing) intersect {1} && binsof(Reading) intersect {1};
            }
            FULL:       cross Writing,Reading,FULL_BIN {
                illegal_bins full_1= binsof(FULL_BIN)  intersect {1} && binsof(Reading) intersect {1} ;
            }
            EMPTY:      cross Writing,Reading,EMPTY_BIN{
                illegal_bins empty_1= binsof(EMPTY_BIN)  intersect {1} && binsof(Writing) intersect {1} iff (item.rst_n);
            }
            ALMOSTFULL: cross Writing,Reading,ALMOSTFULL_BIN;
            ALMOSTEMPTY:cross Writing,Reading,ALMOSTEMPTY_BIN;
            UNDERFLOW:  cross Writing,Reading,UNDERFLOW_BIN{
                illegal_bins UNDERFLOW1=binsof(UNDERFLOW_BIN) intersect {1} && binsof(Writing) intersect {1};
                illegal_bins UNDERFLOW2=binsof(UNDERFLOW_BIN) intersect {1} && binsof(Writing) intersect {0} && binsof(Reading) intersect {0};
            }
            reset_check:cross Reset,ack_BIN,OF_BIN,FULL_BIN,EMPTY_BIN,ALMOSTFULL_BIN,ALMOSTEMPTY_BIN,UNDERFLOW_BIN{
                bins reset_ch=binsof(Reset.low) && binsof(ack_BIN.ack_low) && binsof(OF_BIN.OF_low) && binsof(FULL_BIN.FULL_low) 
                              && binsof(EMPTY_BIN.EMPTY_high) && binsof(ALMOSTFULL_BIN.AF_low) && binsof(ALMOSTEMPTY_BIN.AE_low) && binsof(UNDERFLOW_BIN.UF_low)  ;
                option.cross_auto_bin_max=0;
            }
        endgroup


        function new(string name = "fifo_coverage", uvm_component parent =null);
            super.new(name,parent);
            check_state=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
          cov_fifo=new("covarage fifo",this);
          cov_ep=new("coverage export",this);
        endfunction

        function void connect_phase(uvm_phase phase);  
            super.connect_phase(phase);
            cov_ep.connect(cov_fifo.analysis_export);
        endfunction  

        task run_phase(uvm_phase phase);  
            super.run_phase(phase);
            forever begin
            cov_fifo.get(item);
            check_state.sample();
            end

        endtask      
  
    endclass
endpackage