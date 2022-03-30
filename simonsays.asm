# Katelyn Kunzmann CS 0447 Project 2 - Simon
.data
	gameArrayLength:		.word	0
	gameArray:		.space	300
.text
start_game:
	bne $t9, 16, start_game
	addi $t8, $zero, 16
	
run_game:
	addi $v0, $zero, 42		# Syscall 42: Random int range
	addi $a0, $zero, 0		# ID of random num
	addi $a1, $zero, 4		# Upper bound
	syscall
	addi $a0, $a0, 1			# $a0 += 1
	
	lw $t0, gameArrayLength		# loads size of the array into $t0
	la $t1, gameArray($t0)		# loads address of the start of the game array + current size into $t1
	sb $a0, ($t1)			# Stores random num into game array + current size
	addi $t0, $t0, 1			# Increment array size
	sw $t0, gameArrayLength		# Store updated size of array
	
	addi $t3, $zero, 0		# Initialize count | $t3
	lw $t0, gameArrayLength		# loads size of the array into $t0

loop_sequence:		# Loop through play sequence with each byte
	beq $t3, $t0, userside		# branch when count matches array size
	lb $a0, gameArray($t3)		
	jal _playSequence
	addi $t3, $t3, 1			# Increment count
	j	loop_sequence
userside:
	addi $t3, $zero, 0		# Reinitialize count
	lw $t0, gameArrayLength
loop_sequence2:
	beq $t3, $t0, run_game
	lb $a0, gameArray($t3)
	jal _userPlay
	beq $v0, 0, reset_game		# If user was incorrect, reset game
	addi $t3, $t3, 1			# Otherwise, increment count and continue
	j	loop_sequence2
		
reset_game:		# Reset everything
	addi $t8, $zero, 15
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	lw $t0, gameArrayLength
reset_loop:
	beq $t3, $t0, clear
	sb $t2, gameArray($t3)		
	addi $t3, $t3, 1
	j	reset_loop
clear:
	sw $t2, gameArrayLength		# Starts with 0 if started again
	add $v0, $zero, $zero
	add $a0, $zero, $zero
	add $a1, $zero, $zero
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t8, $zero, $zero
	add $t9, $zero, $zero
	j	start_game


_playSequence:		# $a0 = current random num
	beq $a0, 1, blue
	beq $a0, 2, yellow
	beq $a0, 3, green
	beq $a0, 4, red
blue:
	addi $t8, $zero, 1	
	j	continue
yellow:
	addi $t8, $zero, 2
	j	continue
green:
	addi $t8, $zero, 4
	j	continue
red:	
	addi $t8, $zero, 8
	j	continue
			
continue:
	jr	$ra
		

_userPlay:				# Checking if user is correct or not
resetClick:
	addi $t9, $zero, 0		# Buttons ready
	addi $t4, $a0, 0			# $t4 = $a0 | Current num to be checked
	
buttonClick:
	beq $t9, 1, blueClick
	beq $t9, 2, yellowClick
	beq $t9, 4, greenClick
	beq $t9, 8, redClick
	j	buttonClick
	
blueClick:
	addi $t8, $zero, 1
	beq $t4, 1, correct
	j	wrong
yellowClick:
	addi $t8, $zero, 2
	beq $t4, 2, correct
	j	wrong
greenClick:
	addi $t8, $zero, 4
	beq $t4, 3, correct
	j	wrong
redClick:
	addi $t8, $zero, 8
	beq $t4, 4, correct
	j	wrong

correct:
	addi $v0, $zero, 1
	jr	$ra

wrong:
	addi $v0, $zero, 0
	jr	$ra
	
