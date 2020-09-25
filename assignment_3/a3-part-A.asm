
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	addi $a1, $zero, 9
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

################## Student Name: Jakob Valen 
################# Student ID #: V00943160	
	
dump_array: 

 	addi $sp,$sp,-12
 	sw $t1,4($sp)  
 	sw $t2,8($sp)  
 	sw $t3,12($sp)
 	
 	add $t1,$zero,$zero # $t1 will hold the current address of the current number within the array
 	add $t2,$zero,$zero # $t2 will act as our offset to read in each number within the array
 	add $t3,$zero,$a0  # $t3 will hold the original data address passed in $a1 when demp_array was called
 	
 	
 	print_loop:
 		beqz $a1,done_array_dump # Check if we have printed all the numbers within the array
 		subi $a1,$a1,1  
 		add $t1,$t2,$t3 # Read in the current numbers address within the array
 		addi $t2,$t2,4 
 		
 		lw $a0,0($t1) # print the current number within the array 
 		addi $v0,$zero,1 
 		syscall 
 		
 		la $a0,SPACE  # Print the space character after each time we print a number
 		addi $v0,$zero,4 
 		syscall 
 		
 		b print_loop
 		 
 	 

	done_array_dump: 
	 	
		la $a0,NEWLINE   # Once we have finished printing the array, print the newline character
		addi $v0,$zero,4 
		syscall 
		
		lw $t1,4($sp) # Restore the stack
		lw $t2,8($sp)  
		lw $t3,12($sp)
		addi $sp,$sp,12
		jr $ra
	
	
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
