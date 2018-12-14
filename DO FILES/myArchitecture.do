vsim -gui work.myArchitecture
add wave sim:/myArchitecture/*
force -freeze sim:/myArchitecture/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/myArchitecture/ramClk 0 0, 1 {50 ps} -r 100

#mem load -filltype value -filldata FFFFFFFF -fillradix hexadecimal /myArchitecture/myArchitectureMap/ramMap/ram(8)
add mem /myarchitecture/ramMap/ram -a decimal -d decimal -wo 1

mem load -filltype value -filldata 10 -fillradix decimal /myarchitecture/ramMap/ram(10)
mem load -filltype value -filldata 11 -fillradix decimal /myarchitecture/ramMap/ram(11)
mem load -filltype value -filldata 12 -fillradix decimal /myarchitecture/ramMap/ram(12)
mem load -filltype value -filldata 13 -fillradix decimal /myarchitecture/ramMap/ram(13)
mem load -filltype value -filldata 14 -fillradix decimal /myarchitecture/ramMap/ram(14)
mem load -filltype value -filldata 15 -fillradix decimal /myarchitecture/ramMap/ram(15)



force -freeze sim:/myArchitecture/specialRegRst 16#3 0
force -freeze sim:/myArchitecture/specialRegSrcA 16#0 0
force -freeze sim:/myArchitecture/specialRegDstA 16#0 0
force -freeze sim:/myArchitecture/specialRegDstB 16#0 0
force -freeze sim:/myArchitecture/specialRegSrcEnA 16#0 0
force -freeze sim:/myArchitecture/specialRegDstEnA 16#0 0
force -freeze sim:/myArchitecture/specialRegDstEnB 16#0 0
force -freeze sim:/myArchitecture/readEn 16#0 0
force -freeze sim:/myArchitecture/writeEn 16#0 0
force -freeze sim:/myArchitecture/regRst 16#FF 0

force -freeze sim:/myArchitecture/specialRegDstEnB 16#0 0

run

force -freeze sim:/myArchitecture/regRst 16#0 0
force -freeze sim:/myArchitecture/specialRegRst 16#0 0

#Place 8 in MAR
force -freeze sim:/myArchitecture/busA 16#0008 0
force -freeze sim:/myArchitecture/specialRegDstA 16#0 0
force -freeze sim:/myArchitecture/specialRegSrcEnA 16#0 0
force -freeze sim:/myArchitecture/specialRegDstEnA 16#1 0

run


force -freeze sim:/myArchitecture/specialRegDstEnA 16#0 0
noforce sim:/myArchitecture/busA

force -freeze sim:/myArchitecture/readEn 16#1 0

run


force -freeze sim:/myArchitecture/readEn 16#0 0

force -freeze sim:/myArchitecture/specialRegSrcEnA 16#1 0
force -freeze sim:/myArchitecture/specialRegSrcA 16#1 0

run

force -freeze sim:/myArchitecture/specialRegSrcEnA 16#0 0
force -freeze sim:/myArchitecture/regDstEnA 16#0 0
force -freeze sim:/myArchitecture/regDstA 16#4 0

run

#place B in R1 through B bus
force -freeze sim:/myArchitecture/busB 16#000B 0
force -freeze sim:/myArchitecture/regDstB 16#1 0
force -freeze sim:/myArchitecture/regDstEnB 16#1 0
force -freeze sim:/myArchitecture/regDstEnA 16#0 0

run

#Place A in MAR through B bus
force -freeze sim:/myArchitecture/regDstEnB 16#0 0
force -freeze sim:/myArchitecture/busA 16#000A 0
force -freeze sim:/myArchitecture/specialRegDstB 16#0 0
force -freeze sim:/myArchitecture/specialRegSrcEnA 16#0 0
force -freeze sim:/myArchitecture/specialRegDstEnB 16#1 0

run

#read from memory
force -freeze sim:/myArchitecture/readEn 16#1 0
force -freeze sim:/myArchitecture/specialRegDstEnB 16#0 0
noforce sim:/myArchitecture/busA
noforce sim:/myArchitecture/busB

######################################################

run
# Out MDR to bus A
force -freeze sim:/myArchitecture/readEn 16#0 0

force -freeze sim:/myArchitecture/specialRegSrcEnA 16#1 0
force -freeze sim:/myArchitecture/specialRegSrcA 16#1 0

run


# Out R1 to bus A
force -freeze sim:/myArchitecture/regSrcA 16#1 0
force -freeze sim:/myArchitecture/regSrcEnA 16#1 0

run

# Get R1 into MDR and R1 into R3

force -freeze sim:/myArchitecture/regSrcEnA 16#0 0

force -freeze sim:/myArchitecture/specialRegDstA 16#1 0
force -freeze sim:/myArchitecture/specialRegDstEnA 16#1 0


force -freeze sim:/myArchitecture/RegDstA 16#3 0
force -freeze sim:/myArchitecture/RegDstEnA 16#1 0

run
force -freeze sim:/myArchitecture/specialRegDstEnA 16#0 0

#write to memory
force -freeze sim:/myArchitecture/writeEn 16#1 0

run

force -freeze sim:/myArchitecture/writeEn 16#0 0

force -freeze sim:/myArchitecture/specialRegSrcEnA 16#1 0
force -freeze sim:/myArchitecture/specialRegSrcA 16#1 0

run

force -freeze sim:/myArchitecture/specialRegSrcEnA 16#0 0
run