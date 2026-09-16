leaf_example:
    #we first makespace on stack
    addi x2, x2, -12

    #registers saved
    sw x18, 8(x2)
    sw x19, 4(x2)
    sw x20, 0(x2)

    #g+h
    add x18, x10, x11
    #i+j
    add x19, x12, x13
    #f=(g+h)-(i+j)
    sub x20, x18, x19

    addi x10, x20, 0
    
    lw x20, 0(x2)
    lw x19, 4(x2)
    lw x18, 8(x2)

    #restore stack and return
    addi x2, x2, 12
    jalr x0, 0(x1)