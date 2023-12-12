lui a0, 0xBFC00   # Load the upper immediate PC base
jalr ra, a0, 0x8  # Jump to two lines down, set return address to slli
slli  a1, a0, 0x2 # shift left a0 by 2 and store in a1 
addi a2, x0, 0x1  # set a2 to 1
jalr x0, ra, 0x0  # return to slli, set return address to jalr
