addi x25, x0, 0x200
addi x5, x0, 10
addi x22, x0, 0
Loop1:
    slli x10, x22, 2
    add x10, x10, x25
    sw x22, 0(x10)
    addi x22, x22, 1
    blt x22, x5, Loop1
addi x22, x0, 0
Loop2:
    slli x10, x22, 2
    add x10, x10, x25
    lw x9, 0(x10)
    add x23, x23, x9
    addi x22, x22, 1
    blt x22, x5, Loop2