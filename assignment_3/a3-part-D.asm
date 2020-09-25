# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_x 120
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  

################## Student Name: Jakob Valen 
################## Student ID #: V00943160

################################# 
# Code from lab08-C.asm 
#################################
la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
lb $s1, 0($s0)
ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
sb $s1, 0($s0) 
################################# 


addi $a2,$zero,BOX_COLOUR  

jal draw_bitmap_box 


	# initialize variables	
check_for_event:  

	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $s1, $zero, check_for_event 
	
	la $t0,KEYBOARD_EVENT 
	lw $t1,0($t0)  
	
	add $t2,$zero,$zero 
	
	sw $t2,0($s0) # Reset pending events 
	
	
	
	# Check if either a,b,c,d or space have been pressed, 
	# if not continue to check for pending events
	beq $t1,LETTER_a,A_KEY  
	
	beq $t1,LETTER_d,D_KEY  
	
	beq $t1,LETTER_w,W_KEY  
	
	beq $t1,LETTER_x,X_KEY 
	
	b check_for_event 
	
	A_KEY:  
		add $a2,$zero,$zero 
		jal draw_bitmap_box
		la $t4,BOX_COLUMN
		lw $t5,0($t4) 
		subi $t5,$t5,1 
		sw $t5,0($t4) 
		addi $a2,$zero,BOX_COLOUR 
		jal draw_bitmap_box 
		b check_for_event 
	
	D_KEY: 
		add $a2,$zero,$zero 
		jal draw_bitmap_box
		la $t4,BOX_COLUMN
		lw $t5,0($t4) 
		addi $t5,$t5,1 
		sw $t5,0($t4)  
		addi $a2,$zero,BOX_COLOUR
		jal draw_bitmap_box 
		b check_for_event 
	
	W_KEY: 
		add $a2,$zero,$zero 
		jal draw_bitmap_box
		la $t4,BOX_ROW
		lw $t5,0($t4) 
		subi $t5,$t5,1 
		sw $t5,0($t4)   
		addi $a2,$zero,BOX_COLOUR
		jal draw_bitmap_box 
		b check_for_event 
	
	X_KEY: 
		add $a2,$zero,$zero 
		jal draw_bitmap_box
		la $t4,BOX_ROW
		lw $t5,0($t4) 
		addi $t5,$t5,1 
		sw $t5,0($t4) 
		addi $a2,$zero,BOX_COLOUR 
		jal draw_bitmap_box 
		b check_for_event

	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10
	syscall



# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
	
	addi $sp,$sp,-12 
	sw $ra,4($sp)  
	sw $t0,8($sp) 
	sw $t1,12($sp) 
	
	la $t0,BOX_ROW
	la $t1,BOX_COLUMN 
	lw $a0,0($t0) 
	lw $a1,0($t1) 
	
	addi $t9,$zero,4
	
	
	col_1_loop: 
		beqz $t9,pre_col_2 
		jal set_pixel 
		subi $t9,$t9,1 
		addi $a0,$a0,1 # Move to the next row
		b col_1_loop 
	
	pre_col_2: 
	addi $a1,$a1,1  # Move 1 column to the right
	subi $a0,$a0,4  # Reset our row back to it's orginal row number
	addi $t9,$zero,4  # Reset our counter
	
	# All the code below is a simple rinse and repeat cycle of the code segment above
	
	col_2_loop: 
		beqz $t9,pre_col_3 
		jal set_pixel 
		subi $t9,$t9,1 
		addi $a0,$a0,1 
		b col_2_loop 
	
	pre_col_3: 
	addi $a1,$a1,1 
	subi $a0,$a0,4 
	addi $t9,$zero,4  
	
	col_3_loop: 
		beqz $t9,pre_col_4 
		jal set_pixel 
		subi $t9,$t9,1 
		addi $a0,$a0,1 
		b col_3_loop 
	
	pre_col_4: 
	addi $a1,$a1,1 
	subi $a0,$a0,4 
	addi $t9,$zero,4 
	
	 
	col_4_loop: 
		beqz $t9,exit_draw_box 
		jal set_pixel 
		subi $t9,$t9,1 
		addi $a0,$a0,1 
		b col_4_loop
	
		
	
	# Restore the stack
	exit_draw_box:
		lw $ra,4($sp)  
		lw $t0,8($sp) 
		lw $t1,12($sp)
		addi $sp,$sp,12
		jr $ra

	


	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
############################### 
# Code from lab08-C.asm 
##############################
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


.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
	
