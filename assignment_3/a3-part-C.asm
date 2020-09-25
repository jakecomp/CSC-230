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
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box
	
	addi $a0, $zero, 11
	addi $a1, $zero, 6
	addi $a2, $zero, 0x00ffff00
	jal draw_bitmap_box
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x0099ff33
	jal draw_bitmap_box
	
	addi $a0, $zero, 2
	addi $a1, $zero, 3
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box

	addi $v0, $zero, 10
	syscall
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

################### Student Name: Jakob Valen 
################### Student ID #: V00943160
draw_bitmap_box:  

	addi $sp,$sp,-4 
	sw $ra,4($sp)  
	
	# This code is relatively simple,all we are going to do is draw 4 columns of height 4 pixels to get our 4*4 box
	
	addi $t9,$zero,4 # $t9 will act as a counter to display 4 pixels for each row
	
	# Draw the first column
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
		addi $sp,$sp,4
		jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
