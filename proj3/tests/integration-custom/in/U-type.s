lui t0 1

li t1 0

A:

addi t1 t1 1
slli t1 t1 12

beq t1 t0 A


auipc s0 1
auipc t2 50
auipc t0 0
auipc t1 1024
