vsim -gui work.alu
add wave sim:/alu/*
force -freeze sim:/alu/clk 1 0, 0 {50 ps} -r 100

force -freeze sim:/alu/resetFlag 16#1 0

run 

force -freeze sim:/alu/resetFlag 16#0 0

run 

force -freeze sim:/alu/a 16#5 0
force -freeze sim:/alu/b 16#E 0
force -freeze sim:/alu/selectionLines 16#2 0

run

force -freeze sim:/alu/a 16#3 0
force -freeze sim:/alu/b 16#5 0

run


force -freeze sim:/alu/a 16#B 0
force -freeze sim:/alu/b 16#E 0

run

force -freeze sim:/alu/a 16#A 0
force -freeze sim:/alu/b 16#F 0

run

force -freeze sim:/alu/a 16#B 0
force -freeze sim:/alu/b 16#3 0
force -freeze sim:/alu/selectionLines 16#4 0

run

force -freeze sim:/alu/a 16#B 0
force -freeze sim:/alu/b 16#3 0

run


force -freeze sim:/alu/a 16#6 0
force -freeze sim:/alu/b 16#E 0

run

force -freeze sim:/alu/a 16#E 0
force -freeze sim:/alu/b 16#3 0

run