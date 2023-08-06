.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    
    # Prologue


    
    li t0 1
    blt a2 t0 exception1
    blt a3 t0 exception2
    blt a4 t0 exception2

    slli a3 a3 2   # stride * 4
    slli a4 a4 2
    li t4 0 # result

loop_start:
    blt a2 t0 loop_end
    addi t0 t0 1

    lw t1 0(a0)    
    lw t2 0(a1)
    mul t3 t1 t2
    add t4 t4 t3

    add a0 a0 a3
    add a1 a1 a4
    j loop_start

exception1:
    li a0 36
    j exit
exception2:
    li a0 37
    j exit

loop_end:
    mv a0 t4

    # Epilogue


    jr ra
