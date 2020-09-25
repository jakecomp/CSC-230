	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  

############## Student Name: Jakob Valen
############## Student ID #: V00943160

################################# 
# Code from lab08-C.asm 
#################################
la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
lb $s1, 0($s0)
ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
sb $s1, 0($s0) 
#################################

check_for_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $s1, $zero, check_for_event 
	
	la $t0,KEYBOARD_EVENT 
	lw $t1,0($t0)  
	
	add $t2,$zero,$zero 
	
	sw $t2,0($s0) # Reset pending events 
	
	la $t8,KEYBOARD_COUNTS
	
	# Check if either a,b,c,d or space have been pressed, 
	# if not continue to check for pending events
	beq $t1,LETTER_a,A_KEY  
	
	beq $t1,LETTER_b,B_KEY  
	
	beq $t1,LETTER_c,C_KEY  
	
	beq $t1,LETTER_D,D_KEY  
	
	bne $t1,LETTER_space,check_for_event  
	
	jal print_letter
	beq $zero,$zero,check_for_event 
	
	A_KEY:  
		
		lw $t9,0($t8)            # The first 4 bytes of the array will contain the "a" count
		addi $t9,$t9,1 
		sw $t9,0($t8)            # Increment "a" count
		beq $zero,$zero,check_for_event
		 
	
	B_KEY: 
		 
		lw $t9,4($t8)          # The second 4 bytes of the array will contain the "b" count
		addi $t9,$t9,1 
		sw $t9,4($t8)         # Increment "b" count
		beq $zero,$zero,check_for_event 
		
	C_KEY:  
		 
		lw $t9,8($t8)         # The third 4 bytes of the array will contain the "c" count
		addi $t9,$t9,1 
		sw $t9,8($t8)         # Increment "c" count
		beq $zero,$zero,check_for_event 
		
	D_KEY: 
		 
		lw $t9,12($t8)        # The fourth 4 bytes of the array will contain the "d" count
		addi $t9,$t9,1 
		sw $t9,12($t8)        # Increment "d" count
		beq $zero,$zero,check_for_event
	
	 		
print_letter:  

		lw $a0,0($t8)         # print "a" count
		addi $v0,$zero,1 
		syscall 
		
		la $a0,SPACE
		addi $v0,$zero,4 
		syscall 
		
		lw $a0,4($t8)       # print "b" count
		addi $v0,$zero,1 
		syscall  
		
		la $a0,SPACE
		addi $v0,$zero,4 
		syscall 
		
		lw $a0,8($t8)      # print "c" count
		addi $v0,$zero,1 
		syscall 
	
		la $a0,SPACE
		addi $v0,$zero,4 
		syscall 
		
		lw $a0,12($t8)      # print "d" count
		addi $v0,$zero,1 
		syscall 
		
		la $a0,NEWLINE 
		addi $v0,$zero,4 
		syscall 
		
		jr $ra

				
		
		
	.kdata 
################################ 
# Code from lab08-C.asm 
################################	
	.ktext 0x80000180
__kernel_entry: 
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt  
	
	beq $zero,$zero, __exit_exception

__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_keyboard_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	
	beq $zero, $zero, __exit_exception	# otherwise, we return exit kernel 
################################
	
__is_keyboard_interrupt:
	addi $k0,$zero,1 
	la $k1,KEYBOARD_EVENT_PENDING 
	sw $k0,0($k1)                    # Store 1 in KEYBOARD_EVENT_PENDING memory to tell main a keyboard event has occured
	la $k0,0xffff0004
	lw $k1,0($k0)   
	la $k0,KEYBOARD_EVENT 
	sw $k1,0($k0)                    # Store the character pressed on the keyboard in memory
	
	beq $zero, $zero, __exit_exception 


	
__exit_exception:
	eret
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
