strcpy:
    #first we mak space on stack and save reg x19
    addi x2, x2, -4
    sw x19, 0(x2)
    #i=0
    addi x19, x0, 0
Loop:
    #we get address of y[i]
    add x5, x11, x19
    #load y[i]
    lbu x6, 0(x5)
    #address x[i]
    add x7, x10, x19

    #y[i]copied in x[i]
    sb x6, 0(x7)
    #exit if null
    beq x6, x0, Exit

    #i+=1
    addi x19, x19, 1
    beq x0, x0, Loop
Exit:
    lw x19, 0(x2)
    addi x2, x2, 4
    jalr x0, 0(x1)