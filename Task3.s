.text
.globl main
#x20=a, x21=b, x22=d, x23=e
#x5 x6 temp registers
main:
#int a=5
    addi x20, x0, 5
#int b = 0+0
    add x21, x0, x0
#a=b+32
    addi x20, x21, 32
#int d =(a+b)-5
    add x22, x20, x21
    addi x22, x22, -5

#int e = (((a - d)+ (b - a)) + d)

    sub x5, x20, x22
    sub x6, x21, x20
    add x23, x5, x6
    add x23, x23, x22


#e = a + b + d + e;
    add x5, x20, x21
    add x5, x5, x22
    add x23, x5, x23

end:
    j end