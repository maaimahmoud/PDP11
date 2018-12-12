vsim -gui work.specialreg
add wave sim:/specialreg/*
force -freeze sim:/specialreg/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/specialreg/ramClk 0 0, 1 {25 ps} -r 50

mem load -filltype value -filldata FFFFFFFF -fillradix hexadecimal /specialreg/specialRegMap/ramMap/ram(8)


force -freeze sim:/specialreg/myBus 0008 0
force -freeze sim:/specialreg/dst 0 0
force -freeze sim:/specialreg/src_en 0 0
force -freeze sim:/specialreg/dst_en 1 0
run


force -freeze sim:/specialreg/dst_en 0 0
noforce sim:/specialreg/myBus

run

force -freeze sim:/specialreg/readEn 1 0

force -freeze sim:/specialreg/src_en 1 0
force -freeze sim:/specialreg/src 1 0

run

force -freeze sim:/specialreg/readEn 0 0