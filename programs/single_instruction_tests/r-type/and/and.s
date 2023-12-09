# Initialize loop counter
addi t0, 0(x0)

# Loop condition
loop:
    # Compare loop counter with a constant value
    addi t1, 10(x0)
    bne t0, t1, loop_end

    # Loop body
    

    # Increment loop counter
    addi t0, t0, 1

    # Jump back to the loop condition
    beq x0, x0, loop

loop_end:
