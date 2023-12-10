# Initialize loop counter
addi t0, x0, 0

# Loop condition
loop:
    # Compare loop counter with a constant value
    addi t1, x0, 40
    beq t0, t1, loop_end

    # Loop body
    lw a2, 0(t0)
    lw a3, 4(t0)
    and a1, a2, a3

    # Increment loop counter
    addi t0, t0, 8

    # Jump back to the loop condition
    beq x0, x0, loop

loop_end:
