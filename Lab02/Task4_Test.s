addi x5, x0, 2
addi x6, x0, 3
addi x10, x0, 0x200

addi x7, x0, 0

Loop1:
    addi x29, x0, 0

Loop2:
    slli x9, x29, 4
    add x9, x9, x10
    add x28, x7, x29
    sw x28, 0(x9)

    addi x29, x29, 1
    blt x29, x6, Loop2

    addi x7, x7, 1
    blt x7, x5, Loop1