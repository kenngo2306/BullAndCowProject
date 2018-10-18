.data
word:	.asciiz "BABE"	#assigned word
input:	.asciiz "Get input: "
buffer:	.space	20
endl:	.asciiz "\n"
bull:	.word 0		#count BULLs
counter:.word 0		#get the next index
index:	.word 0		#count the index till it reaches 4 then ends
ans:	.asciiz		#holds the input of the user


.text
main:

	#reset bull
	lw $t4, bull
	add $t4, $zero, $zero
	sw $t4, bull
	
	#reset index
	lw $t4, index
	add $t4, $zero, $zero
	sw $t4, index
	
	#reset counter
	lw $t4, counter
	add $t4, $zero, $zero
	sw $t4, counter
	
	li $v0, 4
	la $a0, input
	syscall
	
	#get string
	li $v0, 8
	la $a0, buffer
	li $a1, 5
	move $t1,$a0 	#save string to t0
	syscall
	sw $t1, ans
	
	#End line
	li $v0, 4
	la $a0, endl
	syscall
	
	
	
getIndex:
	lw $s0, counter
	la $t0, word
	lw $t1, ans
	
	#get character index of the word
	addu $t0, $t0, $s0
	lbu $t2, ($t0)
	
	#get character index of the answer
	addu $t1, $t1, $s0
	lbu $t3, ($t1)
	
	#get the next index for the next loop
	addi $s0, $s0, 1
	sw $s0, counter
	
	#BULL
	beq $t2, $t3, equal
	j encounter

equal:
	#increment bull
	lw $t4, bull
	addi $t4, $t4, 1
	sw $t4, bull
	
	#increment the index ( < 4)
	lw $t4, index
	addi $t4, $t4, 1
	sw $t4, index
	
	#check if index = 4 -> output
	lw $t4, index
	beq $t4, 4, output
	j getIndex
	
encounter:
	#increment the index ( <=4)
	lw $t4, index
	addi $t4, $t4, 1
	sw $t4, index
	
	#heck if index = 4
	lw $t4, index
	beq $t4, 4, output
	j getIndex
	
output:
	

	#display bull
	li $v0, 1
	lw $t4, bull
	move $a0, $t4
	syscall
	
	#end Line
	li $v0, 4
	la $a0, endl
	syscall
	
	#check if bull = 4 -> endgame, not, loop main
	lw $t4, bull
	bne $t4, 4, main
	
exit:
	li $v0, 10
	syscall
	
	
	
	
