.text
.globl main
main:
#1
    sw x10, 0x100(x0)

#2
    sw x11,0x1F0(x0)

#3
    lhu x12, 0x100(x0)

#4
    lh x13, 0x1F0(x0)

#5
    lb x14, 0x1F0(x0)

end:
    j end