loop1:
lw x2, 0(x0)
lw x3, 4(x0)
beq x2, x3, loop1
loop2:
lw x2, 8(x0)
lw x3, 12(x0)
beq x2, x3, loop2 

