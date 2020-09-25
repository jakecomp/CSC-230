# UVic CSC 230, Summer 2020
# Assignment #1, part B

# Student name: Jakob Valen
# Student number: V00943160


# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.


.text
start:
	lw $8, testcase3   # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv 

	# We will perform the reverse bit sequence for the first 31 bits 
	# or n-1 input bits
	addi $3,$3,31
		
	 shift_loop:
	 	
	 	# Check if we have gone through all 31 bits
	 	beqz $3,exit   
	 	
	 	# Check if the last bit in the input is set  
	 	# and store the result of the AND mask in register 4
	 	andi $4,$8,1  
	 	srl $8,$8,1   
	 
	 	subi $3,$3,1 # Decrement the bit counter
	 	bgtz $4,add_one # Check if the result of the mask is greater than 0 
	 	
	 	#Shift the output register to left by 1
	 	sll $15,$15,1 
	 	b shift_loop 
	 
	  add_one:  
	  	# If the result of the mask is greater than 0 
	  	# add one to the output register and shift to the left by 1
	  	addi $15,$15,1  
	  	sll $15,$15,1 
	  	b shift_loop 
	 
	 
	  
		

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
	
	

.data

testcase1:
	.word	0x00200020    # reverse is 0x04000400

testcase2:
	.word 	0x00300020    # reverse is 0x04000c00
	
testcase3:
	.word	0x1234fedc     # reverse is 0x3b7f2c48
