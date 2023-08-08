.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -12
    sw ra 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)

    # fopen
    li a1 1
    jal fopen

    li t0 -1
    beq t0 a0 fopen_failed

    addi sp sp -4
    sw a0 0(sp)

    # read row and col
    li a2 4 # read 1 int (row)
    lw a1 8(sp)
    jal fread
    li a2 4
    bne a0 a2 fread_failed

    lw a1 12(sp)
    lw a0 0(sp)
    jal fread
    li a2 4
    bne a0 a2 fread_failed

    # alloc space for elements
    lw a1 8(sp)
    lw a2 12(sp)
    lw t0 0(a1)
    lw t1 0(a2)
    mul a0 t0 t1
    addi sp sp -4
    sw a0 0(sp)
    jal malloc
    beq a0 x0 malloc_failed
    
    # read elements
    lw a2 0(sp)
    mv a1 a0
    lw a0 4(sp)
    jal fread
    lw a2 0(sp)
    bne a0 a2 fread_failed
    sw a1 0(sp)

    # fclose
    lw a0 4(sp)
    jal fclose
    bne a0 x0 fclose_failed


    # Epilogue
    lw a0 0(sp)
    lw ra 8(sp)
    addi sp sp 20
    
    jr ra


malloc_failed:
    li a0 26
    j exit

fopen_failed:
    li a0 27
    j exit

fclose_failed:
    li a0 28
    j exit

fread_failed:
    li a0 29
    j exit