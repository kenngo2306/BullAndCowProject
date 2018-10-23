.data
bullPrint:	.asciiz " Bull"
cowPrint:	.asciiz " Cow"
result:	.asciiz "NOAR"	#assigned word
input:	.asciiz "Get input: "
buffer:	.space	36
endl:	.asciiz "\n"
g_index:	.word 0		#get the next index
r_index:	.word 0		#count the result_index till it reaches 4 then ends
bull: 	.word 0
cow:	.word 0
guess:	.asciiz		#holds the input of the user

.text

main:
	li $v0, 4
	la $a0, input
	syscall
	
	#get string
	li $v0, 8
	la $a0, buffer
	li $a1, 5
	move $t1,$a0 	#save string to t0
	syscall
	sw $t1, guess
	
	#End line
	li $v0, 4
	la $a0, endl
	syscall

outterWhile:
	lw $t1, r_index		#t1 = r_index
	bgt $t1, 3, endResult

	lw $t0, g_index
	add $t0, $zero, $zero
	sw $t0, g_index

innerWhile:
	lw $t0, g_index		#t0 = g_index
	lw $t1, r_index		#t1 = r_index
	
	bgt $t0, 3, inR
	
	bne $t0, $t1, cowEqual

	la $t0, result
	lw $t1, guess
	
	lw $s0, r_index
	lw $s1, g_index
	
	addu $t0, $t0, $s0
	lbu $t2, ($t0)
	
	addu $t1, $t1, $s1
	lbu $t3, ($t1)
	
	beq $t2, $t3, bullEqual
	j inG
	

bullEqual:
	lw $t0, bull
	addi $t0, $t0, 1
	sw $t0, bull
	
	j inG

cowEqual:
	la $t0, result
	lw $t1, guess
	
	lw $s0, r_index
	lw $s1, g_index
	
	addu $t0, $t0, $s0
	lbu $t2, ($t0)
	
	addu $t1, $t1, $s1
	lbu $t3, ($t1)
	
	beq $t2, $t3, cowEqual2
	j inG

cowEqual2:
	lw $t1, cow
	addi $t1, $t1, 1
	sw $t1, cow
	
inG:
	lw $t0, g_index
	addi $t0, $t0, 1
	sw $t0, g_index
	j innerWhile

inR:
	lw $t0, r_index
	addi $t0, $t0, 1
	sw $t0, r_index
	j outterWhile
	
endResult:
	li $v0, 1
	lw $t4, bull
	move $a0, $t4
	syscall
	
	li $v0, 4
	la $a0, bullPrint
	syscall
	
	#end Line
	li $v0, 4
	la $a0, endl
	syscall
	
	li $v0, 1
	lw $t4, cow
	move $a0, $t4
	syscall
	
	li $v0, 4
	la $a0, cowPrint
	syscall
	
	#end Line
	li $v0, 4
	la $a0, endl
	syscall
	
	li $v0, 10
	syscall