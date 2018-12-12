vsim -gui work.mux
add wave sim:/mux/*

force -freeze sim:/mux/inputs(0) 16#DD 0
force -freeze sim:/mux/inputs(1) 16#FF 0
force -freeze sim:/mux/selectionLines 16#1 0
run

force -freeze sim:/mux/selectionLines 16#0 0

run