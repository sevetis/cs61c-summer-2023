.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue

    addi t0 x0 1
    blt a1 t0 exception
    lw t1 0(a0)   # t1 = a[0]
    li t3 0  # t3 = 0

loop_start:
    addi t0 t0 1
    addi a0 a0 4
    blt a1 t0 loop_end
    lw t2 0(a0)   # t2 = *(a + 1)
    blt t1 t2 loop_continue # t1 = max(t1, t2)
    j loop_start

loop_continue:
    mv t1 t2
    addi t3 t0 -1 # t3 = current_index
    j loop_start

exception:
    li a0 36
    j exit

loop_end:
    mv a0 t3
    # Epilogue

    jr ra
