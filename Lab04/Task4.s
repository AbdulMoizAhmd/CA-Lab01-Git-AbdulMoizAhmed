#a=3
addi x10, x0, 3
#b=4
addi x11, x0, 4
#call func
jal x1, calculate

#copy ot x11
addi x11, x10, 0

#proint int
addi x10, x0, 1
ecall

jal x0, exit




calculate:
    #make space on stack and save ra
    addi sp, sp, -4
    sw x1, 0(sp)
#call sum, square fucntions
    jal x1, sum
    jal x1, square
    #restore original ra and stack
    lw x1, 0(sp)
    addi sp, sp, 4

    #return
    jalr x0, 0(x1)

sum:

    #x10=a+ b
    add x10, x10, x11

#return
    jalr x0, 0(x1)


square:
    #x10=x10*x10
    mul x10, x10, x10
    jalr x0, 0(x1)

exit:
    jal x0, exit