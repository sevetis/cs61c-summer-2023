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
    addi sp sp -28
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)

    # check argc
    li t0 5 # argc == 5
    bne a0 t0 incorrect_argc

    # store arguments  
    addi sp sp -12
    sw a1 0(sp)
    sw a2 4(sp)

# READ 
    # allocate space for pointer arguments
    li a0 24 # 3 matrices, 6 arguments , 6 * sizeof(int) = 24
    jal malloc
    beq a0 x0 malloc_failed

    mv s0 a0 # store result 
    # s0: 0   4   8   12   16   20  
    #    r0  c0  r1   c1   ri   ci 
         
    # m0
    add a1 s0 x0 # row pointer
    addi a2 s0 4 # col pointer
    lw t0 0(sp) # t0 = argv
    lw a0 4(t0) # a0 = argv[1]

    jal read_matrix
    mv s1 a0 # s1 = m0
    mv s1 a0 # s1 = m0

    # m1
    addi a1 s0 8
    addi a2 s0 12
    lw t0 0(sp)
    lw a0 8(t0)

    jal read_matrix
    mv s2 a0 # s2 = m1

    # input 
    addi a1 s0 16
    addi a2 s0 20
    lw t0 0(sp)
    lw a0 12(t0)

    jal read_matrix
    mv s3 a0 # s3 = input

# H = MATMUL(m0, input) 
    # allocate space
    lw t0 0(s0)     # t0 = m0's height
    lw t1 20(s0)    # t1 = input's width
    mul a0 t0 t1    # numbers of elements
    slli a0 a0 2    # total size

    jal malloc
    beq a0 x0 malloc_failed

    # load arguments
    mv a6 a0    # a6 = result's pointer
    mv a0 s1    # a0 = m0 
    lw a1 0(s0) # a1 = m0's row
    lw a2 4(s0) # a2 = m0's col
    mv a3 s3    # a3 = input
    lw a4 16(s0)# a4 = input's row
    lw a5 20(s0)# a5 = input's col

    mv s4 a6 # s4 = h = m0 x input

    jal matmul

# H = RELU(H)
    mv a0 s4
    
    lw t0 0(s0)
    lw t1 20(s0)
    mul a1 t0 t1

    jal relu

# O = MATMUL(m1, h)
    # allocate space
    lw t0 8(s0) # t0 = m1's height
    lw t1 20(s0) # t1 = h's width = input's width
    mul a0 t0 t1 
    slli a0 a0 2

    jal malloc
    beq a0 x0 malloc_failed

    # load arguments
    mv a6 a0
    mv a0 s2
    lw a1 8(s0)
    lw a2 12(s0)
    mv a3 s4
    lw a4 0(s0)
    lw a5 20(s0)

    mv s5 a6    # s5 = o

    jal matmul

# WRITE OUTPUT FILE
    lw t0 0(sp)  # t0 = argv
    lw a0 16(t0) # a0 = argv[4]

    mv a1 s5
    lw a2 8(s0)
    lw a3 20(s0)

    jal write_matrix

# ARGMAX
    mv a0 s5
    
    lw t0 8(s0)
    lw t1 20(s0)
    mul a1 t0 t1

    jal argmax

    sw a0 0(sp) # save final result in stack, overwrite useless argv

# PRINT
    lw a2 4(sp) # restore print argument
    li t0 1
    beq a2 t0 FREE
    jal print_int
    li a0 '\n'
    jal print_char

FREE:
    mv a0 s0    # free s0
    jal free
    mv a0 s1    # free s1
    jal free
    mv a0 s2    # free s2
    jal free
    mv a0 s3    # free s3
    jal free
    mv a0 s4    # free s4
    jal free
    mv a0 s5    # free s5
    jal free

    # restore final result
    lw a0 0(sp) 
    # EPILOGUE
    addi sp sp 12
    lw s5 24(sp)
    lw s4 20(sp)
    lw s3 16(sp)
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 28

    jr ra


malloc_failed:
    li a0 26
    j exit

incorrect_argc:
    li a0 31
    j exit