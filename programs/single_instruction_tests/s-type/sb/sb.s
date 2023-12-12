addi a0, zero, 0x12 # Compute value we want to store memory, and store in a0.
sb a0, 0x5(zero) # Store the value of a0 in the fifth byte of memory.
lbu a1, 0x5(zero) # Load the value in fifth byte of memory into a1 register.
