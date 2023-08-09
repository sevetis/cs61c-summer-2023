.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # PROLOGUE
    addi sp sp -16
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)

    # check argc
    li t0 5 # argc = 5
    bne a0 t0 incorrect_argc

    # save arguments  
    addi sp sp -12
    sw a1 0(sp)
    sw a2 4(sp)

# READ m0
     # allocate space for pointer arguments
    li a0 8 # 2 int
    jal malloc

    beq a0 x0 malloc_failed
     # read 
    mv a1 a0 # a1 = a0
    addi a2 a1 4 # a2 = a0 + 4
    lw t0 0(sp) # t0 = argv
    lw a0 4(t0) # a0 = argv[1]

    jal read_matrix
    mv s0 a0 # s0 = m0

# READ m1
     # allocate space 
    li a0 8
    jal malloc

    beq a0 x0 malloc_failed
     #read 
    mv a1 a0
    addi a2 a1 4
    lw t0 0(sp)
    lw a0 8(t0)

    jal read_matrix
    mv s1 a0 # s1 = m1

# READ INPUT
     # allocate 
    li a0 8
    jal malloc

    beq a0 x0 malloc_failed
     # read 
    mv a1 a0
    addi a2 a1 4
    lw t0 0(sp)
    lw a0 12(t0)

    jal read_matrix
    mv s2 a0 # s2 = input

# MATMUL(m0, input)





    # EPILOGUE
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 12

    jr ra


malloc_failed:
    li a0 26
    j exit

incorrect_argc:
    li a0 31
    j exit