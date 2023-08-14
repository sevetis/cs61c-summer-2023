addi t0 x0 0
addi t1 x0 10

A:
    addi t0 t0 1
    addi t1 t1 -1
    bge t1 t0 A

beq t0 t1 A

B:
    addi t0 t0 -1
    addi t1 t1 1
    blt t1 t0 B


addi t0 x0 5
addi t1 x0 -5

C:
    addi t1 t1 1
    bgeu t1 t0 C

addi t1 t1 -5

D:
    addi t1 t1 1
    bltu t0 t1 D