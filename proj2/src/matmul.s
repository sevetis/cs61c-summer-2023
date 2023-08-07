.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    li t0 1
    # Error checks
    blt a1 t0 exception # m0: rows < 1
    blt a2 t0 exception #     cols < 1
    blt a4 t0 exception # m1: rows < 1
    blt a5 t0 exception #     cols < 1
    bne a2 a4 exception # m0's cols != m1's rows
    # Prologue
    addi sp sp -8
    sw ra 0(sp)
    sw a6 4(sp)

    mv t0 x0 # i = 0
outer_loop_start:
    bge t0 a1 outer_loop_end    # i < m0's rows
    addi t0 t0 1    # i++

    mv t1 x0 # j = 0    
inner_loop_start:
    bge t1 a5 inner_loop_end    # j < m1's cols
    addi t1 t1 1    # j++

    #Prologue
    addi sp sp -32
    sw t0 0(sp)
    sw t1 4(sp)
    sw a0 8(sp)
    sw a1 12(sp)
    sw a3 16(sp)
    sw a4 20(sp)
    sw a5 24(sp)
    sw a6 28(sp)

    #call dot product
    mv a1 a3
    li a3 1
    jal dot

    sw a0 0(a6)
    addi a6 a6 4

    #Epilogue
    lw a6 28(sp)
    lw a5 24(sp)
    lw a4 20(sp)
    lw a3 16(sp)
    lw a1 12(sp)
    lw a0 8(sp)
    lw t1 4(sp)
    lw t0 0(sp)
    addi sp sp 32

inner_loop_end:




outer_loop_end:


    # Epilogue
    lw a6 4(sp)
    lw ra 0(sp)
    addi sp sp 4

    jr ra

exception:
    li a0 38
    j exit