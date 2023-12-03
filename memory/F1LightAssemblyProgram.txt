setup:
    addi a2, a2, 0x5
    addi a3, a3, 0xff
    addi a4, a4, 0x4b

clock:
    addi a1, a1, 0x1
    bne a1, a2, clock
    sub a1, a1, a2
    beq a0, a3, oddcase

main:
    slli a0, a0, 0x1
    addi a0, a0, 0x1
    beq a0, a3, rng
    jal ra, clock 

rng:
    slli a4, a4, 0x1
    andi a4, a4, 0x3ff
    srli a5, a4, 0x2
    srli a6, a4, 0x9
    andi a5, a5, 0x1
    andi a6, a6, 0x1
    xor a5, a5, a6
    add a4, a4, a5
    andi a2, a2, 0x0
    add  a2, a2, a4
    jal ra, clock 

oddcase:
    andi a0, a0, 0x0
