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
    addi sp sp -8
    sw ra 0(sp)
    sw s0 4(sp)

# OPEN THE FILE
    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)

    li a1 0 # permission
    jal fopen
    
    addi t0 x0 -1   # exception
    beq a0 t0 fopen_failed

    lw a2 4(sp)
    lw a1 0(sp)
    addi sp sp 8

# READ ROW AND COL
    # allocate space
    addi sp sp -12
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)

    li a0 8 # 2 * sizeof(int)
    jal malloc

    beq a0 x0 malloc_failed # exception

    mv s0 a0 # store result

    lw a2 8(sp)
    lw a1 4(sp)
    lw a0 0(sp)
    addi sp sp 12

    # read file
    addi sp sp -12
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)

    mv a1 s0 # pointer to be allocated
    li a2 8 # 2 int
    jal fread

    li a2 8 # exception
    bne a0 a2 fread_failed
    
    lw a2 8(sp)
    lw a1 4(sp)
    lw a0 0(sp)
    addi sp sp 12

    # set row and col
    lw t1 0(s0) # row
    lw t2 4(s0) # cols
    sw t1 0(a1)
    sw t2 0(a2)

# READ MATRIX    
    # allocate space 
    addi sp sp -16
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)

    mul t0 t1 t2 # number of element
    slli t0 t0 2 # n * sizeof(int)
    sw t0 12(sp)

    mv a0 t0
    jal malloc

    beq a0 x0 malloc_failed
    mv t0 a0  # allocated space

    # read file
    lw a0 0(sp)
    lw a2 12(sp) 
    mv a1 t0 # load pointer
    mv s0 t0

    jal fread

    lw a2 12(sp)
    bne a0 a2 fread_failed

    lw a0 0(sp)
    addi sp sp 16

# CLOSE FILE

    jal fclose
    bne a0 x0 fclose_failed

    mv a0 s0 # return value

    # Epilogue
    lw s0 4(sp)
    lw ra 0(sp) 
    addi sp sp 8

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
