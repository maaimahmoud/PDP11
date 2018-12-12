vsim -gui work.andGate
add wave sim:/andGate/*

force -freeze sim:/andGate/inputs(0) 16#CE 0
force -freeze sim:/andGate/inputs(1) 16#FD 0
force -freeze sim:/andGate/inputs(2) 16#CF 0

run

force -freeze sim:/andGate/inputs(1) 16#AB 0

run