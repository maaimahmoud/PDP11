vsim -gui work.regfile
add wave sim:/regfile/*
force -freeze sim:/regfile/clk 0 0, 1 {50 ps} -r 100

force -freeze sim:/regfile/rst 16#FF 0
force -freeze sim:/regfile/dstEnA 16#0 0
force -freeze sim:/regfile/dstEnB 16#0 0
force -freeze sim:/regfile/srcEnA 16#0 0
force -freeze sim:/regfile/srcA 16#0 0
force -freeze sim:/regfile/dstA 16#0 0
force -freeze sim:/regfile/dstB 16#0 0
run


force -freeze sim:/regfile/rst 16#0 0

run

force -freeze sim:/regfile/busA 16#00AA 0
force -freeze sim:/regfile/dstA 16#0 0
force -freeze sim:/regfile/dstEnA 16#1 0

run

force -freeze sim:/regfile/busB 16#00BB 0
force -freeze sim:/regfile/dstB 16#1 0
force -freeze sim:/regfile/dstEnB 16#1 0
force -freeze sim:/regfile/dstEnA 16#0 0
run

force -freeze sim:/regfile/busA 16#00CC 0
force -freeze sim:/regfile/dstA 16#2 0
force -freeze sim:/regfile/dstEnA 16#1 0
force -freeze sim:/regfile/dstEnB 16#0 0
run

force -freeze sim:/regfile/busB 16#00DD 0
force -freeze sim:/regfile/dstB 16#3 0
force -freeze sim:/regfile/dstEnA 16#0 0
force -freeze sim:/regfile/dstEnB 16#1 0
run

force -freeze sim:/regfile/dstEnB 16#0 0
noforce sim:/regfile/busA
noforce sim:/regfile/busB
run

force -freeze sim:/regfile/srcA 16#0 0
force -freeze sim:/regfile/srcEnA 16#1 0

force -freeze sim:/regfile/dstA 16#1 0
force -freeze sim:/regfile/dstEnA 16#1 0

run

force -freeze sim:/regfile/srcEnA 16#1 0
force -freeze sim:/regfile/srcA 16#2 0
force -freeze sim:/regfile/dstA 16#0 0
force -freeze sim:/regfile/dstEnA 16#1 0

run

force -freeze sim:/regfile/srcA 16#3 0
force -freeze sim:/regfile/dstA 16#0 0
force -freeze sim:/regfile/dstEnA 16#1 0
run

force -freeze sim:/regfile/dstEnA 16#0 0

run