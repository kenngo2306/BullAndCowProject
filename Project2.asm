.data
	random_max_value: .word 110
inp:	.space 5
.text
	#Print prompt
	li	$v0, 4
	la	$a0, Prmpt
	syscall
	#Get input string
	li	$v0, 8
	la	$a0, inp
	li	$a1, 5
	syscall
	lb	$t0, inp
	li	$t1, 33 # !
	beq	$t0, $t1, giveup
	slti	$t1, $t0, 97
	li	$t2, 122
	slt	$t2, $t2, $t0
	and	$t1, $t1, $t2
	beq
	
	li $v0, 10
	syscall

success_sound:			# MIDI sound
	li $v0, 31
	li $a0, 72		 	# C pitch (0-127)
	li $a1, 1000 		# duration in milliseconds
	li $a2, 8			# instrument (0-127)
	li $a3, 100 		# volume (0-127)
	syscall

	li $v0, 31
	li $a0, 79		 	# G pitch (0-127)
	li $a1, 1000 		# duration in milliseconds
	li $a2, 8			# instrument (0-127)
	li $a3, 100 		# volume (0-127)
	syscall
	jr $ra
	
generate_random_number:
	lw $a1, random_max_value  	# $a1 to the max value
    li $v0, 42   				# generates the random number.
    syscall
    add $v0, $zero, $a0			# return value to $v0
    jr $ra