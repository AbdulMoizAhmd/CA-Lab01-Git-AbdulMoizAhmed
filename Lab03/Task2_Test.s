# test values
addi x10, x0, 10     # g = 10
addi x11, x0, 7      # h = 7
addi x12, x0, 4      # i = 4
addi x13, x0, 2      # j = 2

# call function
jal x1, leaf_example
j exit


leaf_example:

    # make space on stack
    addi x2, x2, -12

    # save registers
    sw x18, 8(x2)
    sw x19, 4(x2)
    sw x20, 0(x2)

    # g + h
    add x18, x10, x11

    # i + j
    add x19, x12, x13

    # f = (g+h) - (i+j)
    sub x20, x18, x19

    # return answer in x10
    addi x10, x20, 0

    # restore registers
    lw x20, 0(x2)
    lw x19, 4(x2)
    lw x18, 8(x2)

    # restore stack
    addi x2, x2, 12

    # return
    jalr x0, 0(x1)

exit: