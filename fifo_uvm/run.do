vlib work
vlog *v +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/top/if_t/*
coverage save fifo_tb.ucdb -onexit 
run -all
quit -sim

vcover report fifo_tb.ucdb -details -all -output coverage_report.txt
