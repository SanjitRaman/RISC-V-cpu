loop1:
lw a1, 0(x0)
lw a2, 4(x0)
blt a1, a2, loop1
loop2:
lw a1, 8(x0)
lw a2, 12(x0)
blt a1, a2, loop2 
