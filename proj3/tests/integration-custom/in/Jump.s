li t0 10
li t1 0

j A



A:
    jal Add_t1
    bge t0 t1 A

add t2 x0 x0

B:
    jal s0 Add_t2
    bge t0 t2 B
    
j end

Add_t1:
    addi t1 t1 1
    ret

Add_t2:
    addi t2 t2 1
    jalr x0 s0 0

end: