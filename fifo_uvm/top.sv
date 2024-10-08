import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test_pkg::*;
module top();

bit clk=0;

always #100 clk=!clk;


fifo_if if_t(clk);
FIFO dut(if_t);


initial begin
uvm_config_db #(virtual fifo_if)::set(null,"*","virtualIf",if_t);
run_test("fifo_test");
end



endmodule