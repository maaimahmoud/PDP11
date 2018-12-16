vsim -gui work.ControlWordDecoder
add wave sim:/ControlWordDecoder/*

force -freeze sim:/ControlWordDecoder/OPCODE 1011 0
force -freeze sim:/ControlWordDecoder/srcReg 100 0
force -freeze sim:/ControlWordDecoder/dstReg 110 0

# Test F6
force -freeze sim:/ControlWordDecoder/F6 00 0
run
force -freeze sim:/ControlWordDecoder/F6 01 0
run
force -freeze sim:/ControlWordDecoder/F6 10 0
run
force -freeze sim:/ControlWordDecoder/F6 11 0
run

# Test F5
force -freeze sim:/ControlWordDecoder/F5 00 0
run
force -freeze sim:/ControlWordDecoder/F5 01 0
run
force -freeze sim:/ControlWordDecoder/F5 10 0
run
force -freeze sim:/ControlWordDecoder/F5 11 0
run

# Test F4
force -freeze sim:/ControlWordDecoder/F4 000 0
run
force -freeze sim:/ControlWordDecoder/F4 001 0
run
force -freeze sim:/ControlWordDecoder/F4 010 0
run
force -freeze sim:/ControlWordDecoder/F4 011 0
run
force -freeze sim:/ControlWordDecoder/F4 100 0
run
force -freeze sim:/ControlWordDecoder/F4 101 0
run
force -freeze sim:/ControlWordDecoder/F4 110 0
run
force -freeze sim:/ControlWordDecoder/F4 111 0
run

# Test F3

force -freeze sim:/ControlWordDecoder/F3 000 0
run
force -freeze sim:/ControlWordDecoder/F3 001 0
run
force -freeze sim:/ControlWordDecoder/F3 010 0
run
force -freeze sim:/ControlWordDecoder/F3 011 0
run
force -freeze sim:/ControlWordDecoder/F3 100 0
run
force -freeze sim:/ControlWordDecoder/F3 101 0
run
force -freeze sim:/ControlWordDecoder/F3 110 0
run
force -freeze sim:/ControlWordDecoder/F3 111 0
run

# Test F2

force -freeze sim:/ControlWordDecoder/F2 000 0
run
force -freeze sim:/ControlWordDecoder/F2 001 0
run
force -freeze sim:/ControlWordDecoder/F2 010 0
run
force -freeze sim:/ControlWordDecoder/F2 011 0
run
force -freeze sim:/ControlWordDecoder/F2 100 0
run
force -freeze sim:/ControlWordDecoder/F2 101 0
run
force -freeze sim:/ControlWordDecoder/F2 110 0
run
force -freeze sim:/ControlWordDecoder/F2 111 0
run

# Test F1
# ALU is USED
force -freeze sim:/ControlWordDecoder/F1 00 0
run
force -freeze sim:/ControlWordDecoder/F1 01 0
run
force -freeze sim:/ControlWordDecoder/F1 10 0
run
force -freeze sim:/ControlWordDecoder/F1 11 0
run


# ALU is NOT USED
force -freeze sim:/ControlWordDecoder/F4 001 0
#DESTINATION
force -freeze sim:/ControlWordDecoder/F0 1 0

force -freeze sim:/ControlWordDecoder/F1 00 0
run
force -freeze sim:/ControlWordDecoder/F1 01 0
run
force -freeze sim:/ControlWordDecoder/F1 10 0
run
force -freeze sim:/ControlWordDecoder/F1 11 0
run


#Test ALU input Selection Lines
force -freeze sim:/ControlWordDecoder/F4 100 0

force -freeze sim:/ControlWordDecoder/OPCODE 1001 0
force -freeze sim:/ControlWordDecoder/NEXTOPCODE 0011 0

run


force -freeze sim:/ControlWordDecoder/OPCODE 1000 0
force -freeze sim:/ControlWordDecoder/NEXTOPCODE 0011 0

run


force -freeze sim:/ControlWordDecoder/OPCODE 0001 0
force -freeze sim:/ControlWordDecoder/NEXTOPCODE 0101 0

run

force -freeze sim:/ControlWordDecoder/OPCODE 0111 0
force -freeze sim:/ControlWordDecoder/NEXTOPCODE 0101 0

run


force -freeze sim:/ControlWordDecoder/OPCODE 1000 0
force -freeze sim:/ControlWordDecoder/NEXTOPCODE 0101 0

run

force -freeze sim:/ControlWordDecoder/OPCODE 1001 0
force -freeze sim:/ControlWordDecoder/NEXTOPCODE 0101 0

run