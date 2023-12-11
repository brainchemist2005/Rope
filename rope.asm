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
.global str2Rope
str2Rope:
    # Calculate the length of the string
    mv t0, a0          # Save the address of the string
    li t1, 0           # Initialize length counter
calculate_length:
    lbu t2, 0(t0)      # Load the next byte of the string
    beqz t2, length_calculated # If byte is 0 (null terminator), end loop
    addi t1, t1, 1     # Increment length counter
    addi t0, t0, 1     # Move to the next byte
    j calculate_length
length_calculated:

    # Call newRope with the address and length of the string
    mv a1, t1          # Length of the string
    mv a0, a0          # Address of the string
    
    call newRope       # Call newRope to create the rope structure

    # newRope returns the address of the rope in a0
    jr ra