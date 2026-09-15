# thevalues for b and c
addi x22, x0, 10
addi x23, x0, 5

#x valeu
addi x20, x0, 5
#case 1 check
addi x5, x0, 1
beq x20, x5, Case1

#case 2
addi x5, x0, 2
beq x20, x5, Case2
#case 3
addi x5, x0, 3
beq x20, x5, Case3

#case 4
addi x5, x0, 4
beq x20, x5, Case4

#default
addi x21, x0, 0
beq x0, x0, Exit


Case1:
    add x21, x22, x23
    beq x0, x0, Exit

Case2:
    sub x21, x22, x23
    beq x0, x0, Exit

Case3:
    slli x21, x22, 1
    beq x0, x0, Exit
Case4:
    addi x21, x0, 0
    addi x6, x22, 0

Divide:
    addi x5, x0, 2
    blt x6, x5, Exit
    addi x6, x6, -2
    addi x21, x21, 1
    beq x0, x0, Divide
Exit: