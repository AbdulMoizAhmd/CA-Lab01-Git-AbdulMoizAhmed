# Task 4 test

# base address of x
addi x10, x0, 0x200

# base address of y
addi x11, x0, 0x220

# store "HI" in y
addi x5, x0, 72
sb x5, 0(x11)

addi x5, x0, 73
sb x5, 1(x11)

# null character
sb x0, 2(x11)

# call strcpy
jal x1, strcpy
j End


strcpy:

    # make space on stack
    addi x2, x2, -4

    # save x19
    sw x19, 0(x2)

    # i = 0
    addi x19, x0, 0

Loop:

    # address of y[i]
    add x5, x11, x19

    # load y[i]
    lbu x6, 0(x5)

    # address of x[i]
    add x7, x10, x19

    # copy y[i] into x[i]
    sb x6, 0(x7)

    # stop at null character
    beq x6, x0, Exit

    # i = i + 1
    addi x19, x19, 1

    # repeat
    beq x0, x0, Loop

Exit:

    # restore x19
    lw x19, 0(x2)

    # restore stack
    addi x2, x2, 4

    # return
    jalr x0, 0(x1)

End: