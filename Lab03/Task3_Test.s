# test values
addi x10, x0, 0x200
addi x11, x0, 0

addi x5, x0, 5
addi x7, x0, 9

sw x5, 0(x10)
sw x7, 4(x10)

# call swap
jal x1, swap
j exit


swap:

    #find address of v[k]
    slli x6, x11, 2
    add x6, x10, x6

    #load values
    lw x5, 0(x6)
    lw x7, 4(x6)

    # swap values
    sw x7, 0(x6)
    sw x5, 4(x6)

    # return
    jalr x0, 0(x1)

exit: