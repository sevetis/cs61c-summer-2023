.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp sp -4
    sw a0 0(sp)

    addi t0 x0 1            # i = 1
    blt a1 t0 exception     # len < 1 exception

loop_start:
    blt a1 t0 loop_end      # len < i end
    lw t1 0(a0)             # t1 = a[i-1]
    addi t0 t0 1            # i++
    blt t1 zero loop_continue   # if t1 < 0, loop_continue
    addi a0 a0 4            # a0 += 4
    j loop_start            

loop_continue:
    add t1 x0 x0            # t1 = 0
    sw t1 0(a0)             # set to zero
    addi a0 a0 4            # next item
    j loop_start

exception:
    li a0 36                # error code 36
    j exit
loop_end:


    # Epilogue
    lw a0 0(sp)
    addi sp sp 4

    jr ra
