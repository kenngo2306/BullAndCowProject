.data

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