.text
.globl main

#x8 =address of a (char array so 1 byte)
#x9 =address of b (short array so 2 bytes)
#x10= address of c (int array so 4 bytes)
main:
    li x8, 0x100
    li x9, 0x200
    li x10, 0x300


    #test values for a=[1,2, 3, 4]
    li x11, 1
    sb x11, 0(x8)
    li x11, 2
    sb x11, 1(x8)
    li x11, 3
    sb x11, 2(x8)
    li x11, 4
    sb x11, 3(x8)

    #test values for b=[10, 20,30, 40]
    li x11, 10
    sh x11, 0(x9)
    li x11, 20
    sh x11, 2(x9)
    li x11, 30
    sh x11, 4(x9)
    li x11, 40
    sh x11, 6(x9)


    
    lb x5, 0(x8) #load a[0] into x5
    lh x6, 0(x9) #load b[0] into x6
    add x7,x5, x6 #a[0]+b[0]
    sw x7, 0(x10) #store teh answer in c[0]

    lb x5, 1(x8) #2nd loop
    lh x6, 2(x9)
    add x7, x5, x6
    sw x7, 4(x10)

    lb x5, 2(x8) #3rd loop
    lh x6, 4(x9)
    add x7, x5, x6
    sw x7, 8(x10)

    lb x5, 3(x8) #4th loop
    lh x6, 6(x9)
    add x7, x5, x6
    sw x7, 12(x10)

end:
    j end
