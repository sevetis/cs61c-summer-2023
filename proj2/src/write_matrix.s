.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -4
    sw ra 0(sp)

    # OPEN FILE
    addi sp sp -12
    sw a1 0(sp)
    sw a2 4(sp)
    sw a3 8(sp)

    li a1 1

    jal fopen

    li t0 -1
    beq a0 t0 fopen_failed

    lw a3 8(sp)
    lw a2 4(sp)
    lw a1 0(sp)
    addi sp sp 12

    # WRITE ROW AND COL
    addi sp sp -16
    sw a2 0(sp)
    sw a3 4(sp)
    sw a1 8(sp)
    sw a0 12(sp)

    mv a1 sp
    li a2 2 # n = 2
    li a3 4 # size = 4

    jal fwrite

    li a2 2
    bne a0 a2 fwrite_failed

    lw a0 12(sp)
    lw a1 8(sp)
    lw a3 4(sp)
    lw a2 0(sp)
    addi sp sp 16

    # WRITE ELEMENTS
    mul a2 a2 a3 

    addi sp sp -8
    sw a0 0(sp)
    sw a2 4(sp)

    li a3 4

    jal fwrite

    lw a2 4(sp)
    bne a0 a2 fwrite_failed

    lw a0 0(sp)
    addi sp sp 8

    # CLOSE FILE
    jal fclose
    bne a0 x0 fclose_failed


    # Epilogue
    lw ra 0(sp)
    addi sp sp 4

    jr ra


fopen_failed:
    li a0 27
    j exit

fclose_failed:
    li a0 28
    j exit

fwrite_failed:
    li a0 30
    j exit