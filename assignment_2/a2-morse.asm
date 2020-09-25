.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
	#jal save_our_souls

	## morse_flash test for part B
	 #addi $a0, $zero, 0x42   # dot dot dash dot
	 #jal morse_flash
	
	## morse_flash test for part B
	 #addi $a0, $zero, 0x37   # dash dash dash
	 #jal morse_flash
		
	## morse_flash test for part B
	 #addi $a0, $zero, 0x32  	# dot dash dot
	 #jal morse_flash
			
	## morse_flash test for part B
	 #addi $a0, $zero, 0x11   # dash
	 #jal morse_flash	
	
	# flash_message test for part C
	 #la $a0, test_buffer
	 #jal flash_message
	
	# letter_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	 #addi $a0, $zero, 'P'
	 #jal letter_to_code
	
	# letter_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	 #addi $a0, $zero, 'A'
	 #jal letter_to_code
	
	# letter_to_code test for part D
	# the space' is properly encoded as 0xff
	# addi $a0, $zero, ' '
	# jal letter_to_code
	
	# encode_message test for part E
	# The outcome of the procedure is here
	# immediately used by flash_message
	 la $a0, message01
	 la $a1, buffer01
	 jal encode_message
	 la $a0, buffer01
	 jal flash_message
	
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

######### STUDENT NAME: Jakob Valen 
######### Student ID #: V00943160	
	
###########
# PROCEDURE
save_our_souls:  

	addi $sp,$sp,-8 
	sw $ra,4($sp)  
	sw $t3,8($sp) 
	
	addi $t3,$zero,3 # $t3 will act as a counter, set to 3
	
	# Perform the first 3 dots of the SOS signal
	dot_1_loop: 
		
		beqz $t3,pre_dash 
		jal seven_segment_off 
		jal delay_short 
		jal seven_segment_on 
		jal delay_short 
		jal seven_segment_off 
		subi $t3,$t3,1 
		b dot_1_loop 
	
	# Reset our counter back to 3
	 pre_dash: 
	 	addi $t3,$zero,3 
	 	b dash_loop 
	 
	 # Perform the 3 dashes of the SOS signal
	 dash_loop: 
	 	
	 	beqz $t3,pre_dot_2 
	 	jal seven_segment_off 
		jal delay_long 
		jal seven_segment_on 
		jal delay_long 
		jal seven_segment_off 
		subi $t3,$t3,1 
		b dash_loop 
	
	# Reset our counter for the last time back to 3
	pre_dot_2: 
		addi $t3,$zero,3 
		b dot_2_loop 
	
	# Perfor the final 3 dots of the SOS signal
	dot_2_loop: 
	
	 	beqz $t3,done_sos 
		jal seven_segment_off 
		jal delay_short 
		jal seven_segment_on 
		jal delay_short 
		jal seven_segment_off 
		subi $t3,$t3,1 
		b dot_2_loop 
		 
	# Restore the stack
	done_sos:
		lw $ra,4($sp) 
		lw $t3,8($sp)
		addi $sp,$sp,8	
		jr $ra


# PROCEDURE
morse_flash: 
	
	
 	addi $sp,$sp,-16 # Grow the stack and preserve our needed registers
 	sw $ra,4($sp) 
 	sw $t4,8($sp) 
 	sw $t5,12($sp) 
 	sw $t6,16($sp) 
 	
 	# First check for our 0xff special case byte
 	beq $a0,0xff,special_case  
 	
 	# Load in our 1 byte input
 	add $t4,$zero,$a0 # $t4 will hold the high nybble
 	add $t5,$zero,$a0 # $t5 will hold the low nybble
 	
 	
 	add $t6,$zero,$zero # $t6 will hold the result of an and operation with the low nybble
 	
 	srl $t4,$t4,4      # Shift the byte to the right by 4 to get the high nybble of the input byte
 	andi $t5,$t5,0xf   # Perform an and mask to get the low nybble of the input byte
 	
 	# Check if the length of our message is less than 4 
 	# If so, we will need to modify the low nybble
 	blt $t4,4,non_max_length 
 	
 	# The output loop which will flash the encoded message in the low nybble
	flash_loop: 
	
		beqz $t4,morse_flash_end  # Check if we have itertaed through the entire message
		subi $t4,$t4,1         
		andi $t6,$t5,0x8  # Perform the and operation with  00001000 to see if the 4th bit is set or unset
		sll $t5,$t5,1 
		beqz $t6,dot   # If the result of the and is 0 we have a dot, else we have a dash
		 
		dash: 
			 
			jal seven_segment_off 
			jal delay_long 
			jal seven_segment_on 
			jal delay_long 
			jal seven_segment_off 
			b flash_loop 
		
		dot:  
			
			jal seven_segment_off 
			jal delay_short 
			jal seven_segment_on 
			jal delay_short 
			jal seven_segment_off 
			b flash_loop
	
	# If we come across the 0xff special byte 
	# turn off our display followed by 3 long delays 
	# then exit out of the procedure		 
	special_case: 
		jal seven_segment_off 
		jal delay_long 
		jal delay_long 
		jal delay_long 
		b morse_flash_end  
	
	# If the length of the message is less than 
	# 4 we need to ignore the leading zeros		
	non_max_length: 
		addi $t6,$t6,4 
		sub $t6,$t6,$t4 # Shift our low nybble by the difference between the message length and 4
		
		sub_loop: 
			beqz $t6,flash_loop # Once we are done shifting the low nybble, go to the output loop
			subi $t6,$t6,1 
			sll $t5,$t5,1 
			b sub_loop 
	
	# Restore the stack 	
	morse_flash_end:
 		lw $ra,4($sp) 
 		lw $t4,8($sp) 
 		lw $t5,12($sp)  
 		lw $t6,16($sp)
 		addi $sp,$sp,16
		jr $ra

###########
# PROCEDURE
flash_message: 

 	addi $sp,$sp,-32 
 	sw $ra,20($sp) 
 	sw $t4,24($sp) # $t4 will hold the current address of input byte we are analyzing
 	sw $t5,28($sp) 
 	sw $t6,32($sp) 
 	
 	add $t6,$zero,$zero # $t6 will be our offset to read in our input byte
 	add $t5,$a0,$zero   # $t5 will hold our original $a0 value 
 	
 	# Read in each byte from the input and call morse_flash
 	output_loop: 
 	 
 	 	add $t4,$t6,$t5 
 	 	lbu $a0,0($t4) # Here I use lbu instead of lb so that 0xff is properly loaded into $a0, lb will make $a0 0xffffffff for the space char
 	 	beqz $a0,flash_message_done # If our byte is 0, we are done flashing our message
 	 	jal morse_flash # Flash the encoded byte
 	 	addi $t6,$t6,1 # Increment our offset counter
 	 	b output_loop 
 	 
 	# Simply restore the stack	 
 	flash_message_done:
 		lw $ra,20($sp) 
 		lw $t4,24($sp) 
 		lw $t5,28($sp) 
 		lw $t6,32($sp) 
 		addi $sp,$sp,32  
 	
		jr $ra
	
	
###########
# PROCEDURE
letter_to_code: 

	# Preserve our needed registers
	addi $sp,$sp,-32 
	sw $ra,4($sp) 
	sw $t7,8($sp) 
	sw $t8,12($sp) 
	sw $t9,16($sp) 
	sw $t0,20($sp) # $t0 will hold our current letter as we iterate through the letter array
	sw $t5,24($sp)  
	sw $t4,28($sp) 
	sw $t6,32($sp) 
	
	
	add $t7,$zero,$zero 
	
	la $t7,codes # Load in the array address for our letters 
	
	# Ensure all of our needed registers have no pre-existing values in them
	add $t8,$zero,$zero # $t8 will serve as our offset variable to read in the bytes from the letter array
	add $t9,$zero,$zero  # $t9 will hold the current address of the letter we are looking at in the letter array
	add $t5,$zero,$zero # $t5 will hold the address of the dots and dashes once we find the letter in the letter array
	add $t6,$zero,$zero # $t6 will be the length of our encoded message
	add $t4,$zero,$zero # $t4 will be our temporary output byte
	add $v0,$zero,$zero # $v0 will hold our encoded byte
	add $s1,$zero,$zero # $s1 will just be a counter used to reset the $t8 offset variable
	
	 
	# Iterate through the array until we find the letter we need to encode
	letter_search_loop: 
	
	 	add $t9,$t8,$t7 # Read in the letter from array
	 	addi $t8,$t8,8 
	 	lb $t0,0($t9) # load letter into $t0 
	 	addi $s1,$s1,1 # count how many times it takes to find letter in array
	 	
	 	beq $a0,' ',space_char # Check if we are asked to encode a space character
	 	beq $t0,$a0,letter_found # Check if we have found the letter
	 	b letter_search_loop # If not keep searching
	
	# Once we have found our letter, we need to readjust our offset register to properly read in the dots and dashes 
	letter_found:  
		addi $t8,$t8,-8 
		beq $s1,1,letter_found_loop 
		subi $s1,$s1,1  
		b letter_found
		
		# Here we will iterate through byte which holds the dots and dashes corresponding to the letter we want to encode
		letter_found_loop: 
			addi $t8,$t8,1
			add $t5,$t8,$t9 
			lb $t0,0($t5) # Read in the dot or dash or 0
			beq $t0,'.',store_dot 
			beq $t0,'-',store_dash 
			beqz $t0,done_letter_to_code # Once we encounter 0, we know we are done encoding that letter
		
		
		store_dot: 
			addi $t6,$t6,1     # Increment message length 
			sll $t4,$t4,1   # Just shift the temp byte by 1 to the left
			b letter_found_loop 
		
		store_dash: 
			addi $t6,$t6,1  # Increment message length
			addi $t4,$t4,0x8 # Set the 4th bit to 1, then shift to the left by 1
			sll $t4,$t4,1
			b letter_found_loop 
	
	# Set $v0 as 0xff when we encounter a space character
	space_char: 
		addi $v0,$v0,0xff 
		b restore_stack 
	
	# Output the encoded byte message into $v0		
	done_letter_to_code: 
		
		sll $t6,$t6,4  # Make the high nybble store the length of our encoded message
		srl $t4,$t4,4  # Make the low nybble store the encoded dots and dashes
		
		or $v0,$v0,$t6 
		or $v0,$v0,$t4 
		b restore_stack
		
		restore_stack:
			lw $ra,4($sp) 
			lw $t7,8($sp) 
			lw $t8,12($sp) 
			lw $t9,16($sp) 
			lw $t0,20($sp)  
			lw $t5,24($sp) 
			lw $t4,28($sp) 
			lw $t6,32($sp)
			addi $sp,$sp,32
			jr $ra	


###########
# PROCEDURE
encode_message: 
	
	add $t4,$zero,$a0   # $t4 will hold the original data address for the input message
	add $t7,$zero,$a1   # $t7 will hold the original data address for the buffer
	
	# Save our return address
	addi $sp,$sp,-36 
	sw $ra,36($sp)  

	encode_message_loop: 
	
	 	add $t3,$t5,$t4 
	 	add $t6,$t5,$t7 
	 	addi $t5,$t5,1 
	 	lb $a0,0($t3) # Load in the character
	 	beqz $a0,call_flash_message # If we come across the null character, its time to flash our message
	 	
	 	jal letter_to_code # Perform the letter encoding for the letter we are passed in $a0
	 	sb $v0,0($t6) # Store the encoded byte into our buffer
	 	b encode_message_loop 
	 	
	# Restore stack, and reset the registers we used to prepare fot the flash message call	 
	call_flash_message: 
		add $a0,$zero,$zero  
		add $t4,$zero,$zero 
		add $t3,$zero,$zero 
		add $t5,$zero,$zero 
		add $t6,$zero,$zero 
		add $t7,$zero,$zero
		 
	
		lw $ra,36($sp) 
		addi $sp,$sp,36
		jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS
