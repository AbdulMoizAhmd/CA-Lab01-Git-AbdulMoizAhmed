#num=5
addi x10, x0, 5

#call ntri function
jal x1, ntri

#coyp result to x11 to pritn
addi x11, x10, 0

#print
addi x10, x0, 1
ecall

jal x0, exit

ntri:
    #psace for ra and num
    addi sp, sp, -8
#sav ra and num (current)
    sw x1, 4(sp)
    sw x10, 0(sp)

    #x5=1
    addi x5, x0, 1

    #if num <= 1then go to base case
    ble x10, x5, base
    addi x10, x10, -1

#recursive call
    jal x1, ntri

    # save result of ntri(num - 1) and restore orignal num
    addi x6, x10, 0 
    lw x10, 0(sp)

    #ra restroe and stack
    lw x1, 4(sp)
    addi sp, sp, 8

    #num+ntri(num-1)
    add x10, x10, x6

    jalr x0, 0(x1)


base:
    #reutnr 1
    addi x10, x0, 1
    lw x1, 4(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)
exit: