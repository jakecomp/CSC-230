# UVic CSC 230, Summer 2020
# Assignment #1, part C

# Student name: Jakob Valen
# Student number: V00943160


# Compute M % N, where M must be in $8, N must be in $9,
# and M % N must be in $15.


.text
start:
	lw $8, testcase4_M
	lw $9, testcase4_N

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv 
	
	# Check for a divison by 0 
	# If so, return -1 "Error Message"
	beqz $9,error
	
	# In this loop we will keep subtracting N from M 
	# until M is either 0 or a negative sumber
	modulus_loop: 
	
		sub $8,$8,$9 
		bltz $8,rem_not_zero 
		beqz,$8,rem_zero 
		b modulus_loop 
	
	# If M is negative, 
	# add N back to M 
	# and that result is the remainder
	rem_not_zero: 
		add $15,$8,$9 # Store result in register 15
		b exit 
	
	# If the remiander is 0 
	# set register 15 0
	rem_zero: 
		add $15,$15,$0 
		b exit
	
	error: 
		addi $15,$15,-1 
		b exit
	
	

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
		

.data

# testcase1: 370 % 120 = 10
#
testcase1_M:
	.word	370
testcase1_N:
	.word 	120
	
# testcase2: 24156 % 77 = 55
#
testcase2_M:
	.word	24156
testcase2_N:
	.word 	77

# testcase3: 21 % 0 = -1
#
testcase3_M:
	.word	21
testcase3_N:
	.word 	0
	
# testcase4: 33 % 120 = 33
#
testcase4_M:
	.word	33
testcase4_N:
	.word 	120
