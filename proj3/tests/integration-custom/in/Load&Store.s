addi t0 x0 0x110
addi t2 x0 16

addi sp sp -4

sw t0 0(sp)
lb t1 0(sp)

A:
    beq t1 t2 B
    j A

B:
    lh t0 0(sp)

addi sp sp 4