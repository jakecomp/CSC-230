# UVic CSC 230, Summer 2020
# Assignment #1, part A

# Student name: Jakob Valen
# Student number: V00943160


# Compute even parity of word that must be in register $8
# Value of even parity (0 or 1) must be in register $15


.text

start:
	lw $8, testcase1  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# First we will go through the entire 32 bit sequence and 
	# count the number of set bits 
	
	addi $3,$3, 32 # Number of bits in our input word
	addi $4,$4,0 # Our set bit counter  
	
	
	mask_loop: 
		
		
	 	beqz $3,check_even #Check if we have iterated through the entire input word
		
	
		andi $5,$8,1 # Perform the AND mask on the input and store the result in register 5
		subi $3,$3,1   
		beqz $5,unset_bit  # Check if the bit is set or unset
		addi $4,$4,1 # If the bit is set incrament our set bit counter
		srl $8,$8,1 # Shift right for the next bit comparison
		b mask_loop # Repeat instructions
		
	unset_bit: 
		srl $8,$8,1 
		b mask_loop 
	
	check_even: # Now we need to check if we have an even number of set bit 
		
		# We will keep subtracting 2 from our set bit counter 
		# until the set bit counter is either 0 (even) or "-" (odd)
		subi $4,$4,2 
		beqz $4,even 
		bltz $4,odd
		b check_even 
	
	even: 
		addi $15,$15,0 
		b exit
	
	odd: 
		addi $15,$15,1 
		b exit
	
	 
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


exit:
	add $2, $0, 10
	syscall
		

.data

testcase1:
	.word	0x00200020    # even parity is 0

testcase2:
	.word 	0x00300020    # even parity is 1
	
testcase3:
	.word  0x1234fedc     # even parity is is 1

