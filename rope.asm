.text 
.global newRope
newRope:
    # Save the address of the character array
    mv t1, a0

    # Allocate memory for the rope (16 bytes)
    li a7, 9           # syscall number for sbrk
    li a0, 16          # size of the rope structure
    ecall

    # Initialize rLen and rData
    mv t0, a0          # t0 now points to the allocated rope
    sd a1, 0(t0)       # Store rLen (length of the string) in the first dword
    sd t1, 8(t0)       # Store rData (address of the character array) in the second dword

    # Return the address of the rope
    jr ra
.text
.global str2Rope
str2Rope:
    # a0 = address of the null-terminated string
    # Calculate the length of the string
    mv t0, a0          # Save the address of the string
    mv t3 ,a0
    li t1, 0           # Initialize length counter
calculate_length:
    lbu t2, 0(t0)      # Load the next byte of the string
    beqz t2, length_calculated # If byte is 0 (null terminator), end loop
    addi t1, t1, 1     # Increment length counter
    addi t0, t0, 1     # Move to the next byte
    j calculate_length
length_calculated:

    # Allocate memory for the rope (16 bytes)
    li a7, 9           # syscall number for sbrk
    li a0, 16          # size of the rope structure
    ecall

    # Initialize rLen and rData
    mv t2, a0          # t0 now points to the allocated rope
    sd t1, 0(t2)       # Store rLen (length of the string) in the first dword
    sd t3, 8(t2)       # Store rData (address of the character array) in the second dword

    # Return the address of the rope
    mv a0, t2
    jr ra

.global lenRope
lenRope:
    ld a0, 0(a0)    # Charge rLen
    jr ra

.text
.global printRope
printRope:
    # a0 contains the address of the rope

    # Load rLen (length of the string)
    ld t1, 0(a0)       # t1 = rLen

    # Load rData (address of the string)
    ld a1, 8(a0)       # a1 = rData

    # Prepare for Write syscall
    li a0, 1           # File descriptor 1 (stdout)
    mv a2, t1          # a2 = rLen, length of the string to write

    # Syscall for Write
    li a7, 64          # Syscall number for Write in RARS
    ecall

    jr ra              # Return from the routine

.text
.global splitRope
splitRope:
    # a0 = address of original rope, a1 = split index

    # Load original rope's rLen and rData
    ld t2, 0(a0)       # Load rLen of original rope into t2
    ld t3, 8(a0)       # Load rData of original rope into t3

    # Adjust the index if it's out of bounds
    bltz a1, index_zero
    bgt a1, t2, index_equals_rLen
    j proceed
index_zero:
    li a1, 0
    j proceed
index_equals_rLen:
    mv a1, t2
proceed:

    # Allocate first new rope
    li a7, 9           # syscall number for sbrk
    li a0, 16          # size of the rope structure
    ecall
    mv t4, a0          # t4 = address of the first new rope
    sd a1, 0(t4)       # Set rLen of the first new rope
    sd t3, 8(t4)       # Set rData of the first new rope

    # Allocate second new rope
    li a7, 9
    li a0, 16
    ecall
    mv t5, a0          # t5 = address of the second new rope
    sd t2, 0(t5)       # Set rLen of the second new rope
    sub t6, t2, a1     # t6 = rLen - index
    sd t6, 0(t5)
    add t6, t3, a1     # t6 = rData + index
    sd t6, 8(t5)

    # Return the addresses of the two new ropes
    mv a0, t4
    mv a1, t5
    jr ra
