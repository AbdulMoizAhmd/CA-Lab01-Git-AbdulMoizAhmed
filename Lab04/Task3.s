#base add of array
addi x10, x0, 0x200

#len=4
addi x11, x0, 4

#store the array: 3 1 2 4
addi x5, x0, 3
sw x5, 0(x10)

addi x5, x0, 1
sw x5, 4(x10)
addi x5, x0, 4
sw x5, 8(x10)
addi x5, x0, 2
sw x5, 12(x10)
jal x1, bubble

jal x0, exit



bubble:
    # if a == 0, return
    beq x10, x0, return
    # if len == 0, return
    beq x11, x0, return
    #i=0
    addi x5, x0, 0
outer_loop:



    # if i >= len, sorting is complete
    bge x5, x11, return
    #j=i
    addi x6, x5, 0

inner_loop:

    # if j >= len, move to next i
    bge x6, x11, next_i
    #find a[i] addres
    slli x7, x5, 2
    add x7, x10, x7

    #find a[j] address
    slli x28, x6, 2
    add x28, x10, x28

    #load a[i]
    lw x29, 0(x7)

    #load a[j]
    lw x30, 0(x28)
    # if a[i] >= a[j], do not swap
    bge x29, x30, no_swap
    #swap a[i] and a[j]
    sw x30, 0(x7)
    sw x29, 0(x28)

no_swap:
    #j=j+1
    addi x6, x6, 1

    #repeat inner loop
    jal x0, inner_loop

next_i:

    #i=i+1
    addi x5, x5, 1

    #repeat outer loop
    jal x0, outer_loop

return:
    jalr x0, 0(x1)
exit:
    jal x0, exit