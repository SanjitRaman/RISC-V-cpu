addi a0, zero, 0x123 # Compute value we want to store memory, and store in a0.
sh a0, 0x4(zero) # Store the value of a0 in the third half-word of memory.
lhu a1, 0x4(zero) # Load the value in third half-word of memory into a1 register.
