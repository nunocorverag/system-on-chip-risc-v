.data
matrix_a: .word 1, 1, 1, 1, 1, 1, 1, 1, 1 # Matrix A
matrix_b: .word 1, 1, 1, 1, 1, 1, 1, 1, 1 # Matrix B
matrix_c: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Matrix C

.text
.globl main

main:
    # Initialize i counter
    li t0, 0

    # Outer loop for rows (i)
    i_loop:
        # Initialize j counter
        li t1, 0

        # Inner loop for columns (j)
        j_loop:
            # Sum of the product
            li t6, 0

            # Load addresses
            la t3, matrix_a
            la t4, matrix_b

            # Initialize k counter
            li t2, 0

            # Loop for calculating the product
            k_loop:
                # Calculate index for A[i][k]
                li t5, 3
                mul t5, t0, t5
                add t5, t5, t2
                slli t5, t5, 2
                add t5, t3, t5
                lw t5, 0(t5) 

                # Calculate index for B[k][j]
                li a0, 3
                mul a0, t2, a0
                add a0, a0, t1
                slli a0, a0, 2
                add a0, t4, a0
                lw a1, 0(a0)

                mul t5, t5, a1
                add t6, t6, t5 

                # Increment k
                addi t2, t2, 1

                # Check if k < 3
                li a0, 3
                blt t2, a0, k_loop

            # Calculate index for C[i][j]
            li t5, 3
            mul t5, t0, t5
            add t5, t5, t1
            slli t5, t5, 2

            # Store sum in C[i][j]
            la a0, matrix_c
            add a0, a0, t5
            sw t6, 0(a0)

            # Increment j and check
            addi t1, t1, 1
            li t3, 3
            blt t1, t3, j_loop

        # Increment i and check
        addi t0, t0, 1
        li t3, 3
        blt t0, t3, i_loop

    # Print the resulting matrix
    la t3, matrix_c           # Load base address of matrix C
    li t0, 0                  # Initialize row counter (i)

    print_row:
        li t1, 0              # Initialize column counter (j)

        print_col:
            # Calculate address of C[i][j]
            li t4, 3
            mul t4, t0, t4
            add t4, t4, t1
            slli t4, t4, 2
            add t4, t3, t4
            lw a0, 0(t4)

            # Print number
            li a7, 1
            ecall

            # Print space
            li a0, 32
            li a7, 11
            ecall

            addi t1, t1, 1
            li t4, 3
            blt t1, t4, print_col

        # Print newline
        li a0, 10
        li a7, 11
        ecall

        addi t0, t0, 1
        li t4, 3
        blt t0, t4, print_row

    li a7, 10
    ecall