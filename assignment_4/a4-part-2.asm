	.data
	
TEST_A_16x16:
	.byte  	9 3 8 5 7 0 8 3 9 3 4 7 3 5 7 1
       		4 3 2 1 7 8 5 3 7 5 3 6 6 3 1 6
       		7 4 3 1 9 5 4 6 6 3 6 1 6 6 0 7
       		3 8 1 5 0 5 5 0 4 9 2 0 6 2 4 1
       		2 6 5 9 7 2 7 8 4 2 8 0 1 1 0 9
       		5 8 7 1 9 9 7 2 2 3 8 7 2 1 2 4
       		5 6 1 0 8 8 5 7 0 3 4 5 1 4 2 4
       		7 3 6 1 8 5 3 1 4 2 0 0 6 9 7 9
       		0 5 3 4 7 3 8 9 8 5 5 0 2 4 5 5
       		6 6 0 3 8 1 3 2 1 2 5 1 5 0 7 3
       		5 8 8 3 2 7 8 8 5 4 4 4 3 6 3 7
       		4 0 3 0 9 5 7 7 0 4 8 3 0 7 9 0
       		0 6 7 4 9 2 7 0 0 4 9 1 1 9 7 5
       		8 1 2 7 6 1 4 0 3 5 3 8 1 3 3 2
       		2 9 3 7 2 0 3 8 8 3 1 9 8 0 5 8
       		2 9 7 2 1 1 0 7 9 9 9 9 1 4 6 2
	
	.text
main:

# Students may modify this "main" section temporarily for their testing.
# However, when evaluating your submission, all code from lines 1
# to 49 will be replaced by other testing code (i.e., we will only
# keep code from lines 50 onward). If your solution breaks because
# you have ignored this note, then a mark of zero for Part 2
# of the assignment is possible.

	la $a0, TEST_A_16x16
	addi $a1, $zero, 4
	addi $a2, $zero, 0
	jal sum_neighbours		# Test 2a; $v0 should be 30 
	
	
	la $a0, TEST_A_16x16
	addi $a1, $zero, 9
	addi $a2, $zero, 8
	jal sum_neighbours		# Test 2b; $v0 should be 43
	
	la $a0, TEST_A_16x16
	addi $a1, $zero, 15
	addi $a2, $zero, 15
	jal sum_neighbours 		# Test 2c; $v0 should be 19 
	
			
	addi $v0, $zero, 10
	syscall


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	.data
	
# Available for any extra `.eqv` or data needed for your solution.

	.text
	
###################### Student Name: Jakob Valen 
###################### Student ID #: V00943160	
# sum_neighbours:
#
# $a0 is 16x16 byte array
# $a1 is row (0 is topmost)
# $a2 is column (0 is leftmost)
#
# $v0 holds the value of the bytes around the row and column
sum_neighbours: 

 	addi $sp,$sp,-20 
 	sw $t0,4($sp) 
 	sw $t1,8($sp) 
 	sw $t2,12($sp) 
 	sw $t3,16($sp) 
 	sw $t4,20($sp)  
 	
 	add $v0,$zero,$zero 
 	
 	# If we are ever passed an invalid row/col just return 0
 	bge $a1,16,done_sum 
	bge $a2,16,done_sum
	bltz $a1,done_sum 
	bltz $a2,done_sum
 	
 	# This program works by, starting on the current element if the, left/right elements are within the array, 
 	# and if so add them to $v0, if not we just ignore it and move on the either the left/right/up/down elements. This process is repeated 
 	# for all elements above and below the current row of the element
 	    
 	current_row:
 		mul $t0,$a1,16   
 		
 		check_right:
 		addi $t1,$a2,1 
 		bge $t1,16,check_left 
 	
 		current_right: 
 		add $t2,$t1,$t0 
 		add $t3,$a0,$t2 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4 
 	
 		check_left: 
 		subi $t1,$a2,1 
 		bltz $t1,top_row 
 	
 		current_left: 
 		add $t2,$t1,$t0 
 		add $t3,$a0,$t2 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4  
 		b top_row 
 	
 	top_row: 
 		subi $t0,$a1,1 
 		bltz $t0,bottom_row  
 		mul $t0,$t0,16
 		
 		top:  
 		add $t1,$t0,$a2  
 		add $t3,$a0,$t1 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4 
 		
 		check_top_right: 
 		addi $t1,$a2,1 
 		bge $t1,16,check_top_left 
 			
 		top_right: 
 		add $t2,$t1,$t0 
 		add $t3,$a0,$t2 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4  
 		
 		check_top_left: 
 		subi $t1,$a2,1
 		bltz $t1,bottom_row 
 		
 		top_left: 
 		add $t2,$t1,$t0 
 		add $t3,$a0,$t2 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4  
 		b bottom_row
 		
 	
 	bottom_row: 
 		addi $t0,$a1,1 
 		bge $t0,16,done_sum 
 		
 		mul $t0,$t0,16 
 		
 		bottom:  
 		add $t1,$t0,$a2  
 		add $t3,$a0,$t1 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4 
 		
 		check_bottom_right: 
 		addi $t1,$a2,1 
 		bge $t1,16,check_bottom_left 
 			
 		bottom_right: 
 		add $t2,$t1,$t0 
 		add $t3,$a0,$t2 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4  
 		
 		check_bottom_left: 
 		subi $t1,$a2,1
 		bltz $t1,done_sum
 		
 		bottom_left: 
 		add $t2,$t1,$t0 
 		add $t3,$a0,$t2 
 		lb $t4,0($t3) 
 		add $v0,$v0,$t4  
 		b done_sum
 		
 				
 	done_sum: 
	lw $t0,4($sp) 
 	lw $t1,8($sp) 
 	lw $t2,12($sp) 
 	lw $t3,16($sp) 
 	lw $t4,20($sp) 
 	addi $sp,$sp,20

	jr $ra
	
	
# Use here your solution to Part A for this function
# (i.e., copy-and-paste your code).
set_16x16: 

	addi $sp,$sp,-12 
	sw $t0,4($sp) 
	sw $t1,8($sp) 
	sw $t2,12($sp) 
	
	bge $a1,16,restore_stack 
	bge $a2,16,restore_stack  
	bltz $a1,restore_stack 
	bltz $a2,restore_stack
	
	 
	mul $t1,$a1,16 
	
	
	add $t2,$t1,$a2 
	add $a0,$a0,$t2 
	sb $a3,0($a0) 
		
		
	
	restore_stack:
	lw $t0,4($sp) 
	lw $t1,8($sp) 
	lw $t2,12($sp) 
	addi $sp,$sp,12

	jr $ra
	
	
# Use here your solution to Part A for this function
# (i.e., copy-and-paste your code).
get_16x16: 

	addi $sp,$sp,-12 
	sw $t0,4($sp) 
	sw $t1,8($sp) 
	sw $t2,12($sp) 
	
	bge $a1,16,return_zero
	bge $a2,16,return_zero  
	bltz $a1,return_zero 
	bltz $a2,return_zero
	
	mul $t1,$a1,16 
	
	
	add $t2,$t1,$a2 
	add $a0,$a0,$t2 
	lb $v0,0($a0) 
	
	
	b done_get_16X16 
	
	return_zero: 
		add $v0,$zero,$zero
	
	
	
	done_get_16X16:
	lw $t0,4($sp) 
	lw $t1,8($sp) 
	lw $t2,12($sp) 
	addi $sp,$sp,12

	jr $ra
	

# Use here your solution to Part A for this function
# (i.e., copy-and-paste your code).
copy_16x16: 

	addi $sp,$sp,-12 
	sw $t0,4($sp) 
	sw $t1,8($sp) 
	sw $t2,12($sp)   
	
	add $t1,$zero,$zero 
	add $t0,$zero,$zero
	
	col_loop: 
		beq $t1,16,done_copy  
		mul $t5,$t1,16
		b row_loop   
		done_row:
		addi $t1,$t1,1 
		add $t0,$zero,$zero 
		b col_loop
		
		
		
		row_loop: 
			beq $t0,16,done_row 
			add $t6,$t5,$t0 
			add $t9,$a1,$t6 
			lb $t7,0($t9) 
			add $t8,$a0,$t6 
			sb $t7,0($t8)  
			addi $t0,$t0,1 
			b row_loop
			 
			
	
	done_copy:
	lw $t2,12($sp) 
	lw $t1,8($sp) 
	lw $t0,4($sp) 
	addi $sp,$sp,12

	jr $ra


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
