vsim -gui work.regfile
add wave sim:/regfile/*
force -freeze sim:/regfile/clk 1 0, 0 {25 ps} -r 50

force -freeze sim:/regfile/rst 16#FF 0
force -freeze sim:/regfile/dst_en 16#0 0
force -freeze sim:/regfile/src_en 16#0 0
run


force -freeze sim:/regfile/rst 16#0 0

run

force -freeze sim:/regfile/busA 16#00AA 0
force -freeze sim:/regfile/dst 16#0 0
force -freeze sim:/regfile/dst_en 16#1 0

run

force -freeze sim:/regfile/busA 16#00BB 0
force -freeze sim:/regfile/dst 16#1 0
force -freeze sim:/regfile/dst_en 16#1 0
run

force -freeze sim:/regfile/busA 16#00CC 0
force -freeze sim:/regfile/dst 16#2 0
force -freeze sim:/regfile/dst_en 16#1 0
run

force -freeze sim:/regfile/busA 16#00DD 0
force -freeze sim:/regfile/dst 16#3 0
force -freeze sim:/regfile/dst_en 16#1 0
run

force -freeze sim:/regfile/dst_en 16#0 0
noforce sim:/regfile/busA

run

force -freeze sim:/regfile/src 16#0 0
force -freeze sim:/regfile/src_en 16#1 0

force -freeze sim:/regfile/dst 16#1 0
force -freeze sim:/regfile/dst_en 16#1 0

run

force -freeze sim:/regfile/src_en 16#1 0
force -freeze sim:/regfile/src 16#2 0
force -freeze sim:/regfile/dst 16#0 0
force -freeze sim:/regfile/dst_en 16#1 0

run

force -freeze sim:/regfile/src 16#3 0
force -freeze sim:/regfile/dst 16#0 0
force -freeze sim:/regfile/dst_en 16#1 0
run

force -freeze sim:/regfile/dst_en 16#0 0

run