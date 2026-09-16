swap:
    #find address of v[k]
    slli x6, x11, 2
    add x6, x10, x6
    #load v[k] and v[k+1]
    lw x5, 0(x6)
    lw x7, 4(x6)
    #swap the valeus
    sw x7, 0(x6)
    sw x5, 4(x6)
    #return
    jalr x0, 0(x1)