.globl factorial

.data
n: .word 8

.text
# Don't worry about understanding the code in main
# You'll learn more about function calls in lecture soon
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial takes one argument:
# a0 contains the number which we want to compute the factorial of
# The return value should be stored in a0
factorial:
    # YOUR CODE HERE
    add t0 x0 a0    # t0 = x
    addi t1 x0 2    # t1 = 2
    blt a0 t1 zero  # x < 2, x! = 1
loop:
    addi t0 t0 -1   # t0 = t0 - 1
    mul a0 a0 t0    # x = x * t0
    bge t0 t1 loop  # while t0 >= 2
zero:
    bne a0 x0 end
    addi a0 x0 1 # 0! = 1
end:
    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra
