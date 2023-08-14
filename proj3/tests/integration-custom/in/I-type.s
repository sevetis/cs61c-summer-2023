addi t0 x0 1
addi t1 x0 0

andi t0 t0 1
andi t1 t1 1

andi t0 t0 0
andi t1 t1 0

addi t0 t0 0
addi t1 t1 1

ori t0 t0 0
ori t1 t1 0

ori t0 t0 1
ori t1 t1 1

addi t0 t0 0
addi t1 t1 1

xori t0 t0 0
xori t1 t1 0

xori t0 t0 1
xori t1 t1 1

addi t0 t0 1
addi t1 t1 0

slli t0 t0 2
slli t1 t1 3

addi t0 x0 0
addi t1 x0 1024

srli t0 t0 2
srli t1 t1 4

addi t0 t0 0
addi t1 t1 2

srai t0 t0 2
srai t1 t1 2

addi s0 x0 1

addi t0 t0 0
addi t1 t1 1

slti t0 t0 1
slti t1 t1 2

addi t0 x0 -1
addi t1 x0 1

andi t0 t0 1
