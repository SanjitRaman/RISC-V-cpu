lui a3, 0x10
loop1:
lw a1, 0(a3)
lw a2, 4(a3)
beq a1, a2, loop1
loop2:
lw a1, 8(a3)
lw a2, 12(a3)
beq a1, a2, loop2 
