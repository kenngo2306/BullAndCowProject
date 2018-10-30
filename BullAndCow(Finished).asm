.data
bullPrint:	.asciiz " Bull "
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
	#print out "Get input: "
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
	
	jal count_bulls_and_cows
	lw $a0, bull
	li $v0, 1
	syscall
	
	#End line
	li $v0, 4
	la $a0, endl
	syscall
	
	lw $a0, cow
	li $v0, 1
	syscall
	
	
	li $v0, 10
	syscall

	count_bulls_and_cows:
		outterWhile:
			lw $t1, r_index		#t1 = r_index
			bgt $t1, 3, endResult	#Finish condition (when r_index actually >3)
			#lw $t0, g_index
			add $t0, $zero, $zero	#reset g_index to zero before loop through innerWhile
			sw $t0, g_index

		innerWhile:
			lw $t0, g_index		#t0 = g_index
			lw $t1, r_index		#t1 = r_index
	
			bgt $t0, 3, inR		#increment r_index
	
			bne $t0, $t1, cowEqual		#if the 2 index dont match -> check for cow

			la $t0, result
			lw $t1, guess
	
			lw $s0, r_index
			lw $s1, g_index
	
			#compare the 2 letter at index r (for result) and index g (for guess)
			addu $t0, $t0, $s0
			lbu $t2, ($t0)
	
			addu $t1, $t1, $s1
			lbu $t3, ($t1)
	
			#if they are equal and by last condition of the 2 index being equal -> bull
			beq $t2, $t3, bullEqual
			j inG		#increment g_index
	
		bullEqual:
			lw $t0, bull
			addi $t0, $t0, 1
			sw $t0, bull
			j inG

		cowEqual:	#when the r_index != g_index -> go here
			la $t0, result
			lw $t1, guess
			lw $s0, r_index
			lw $s1, g_index
	
			addu $t0, $t0, $s0
			lbu $t2, ($t0)
	
			addu $t1, $t1, $s1
			lbu $t3, ($t1)
	
			beq $t2, $t3, cowEqual2		#condition if the 2 index actual equal -> cow +1
			j inG

		cowEqual2:
			lw $t1, cow
			addi $t1, $t1, 1
			sw $t1, cow
	
		inG:
			lw $t0, g_index
			addi $t0, $t0, 1
			sw $t0, g_index
			j innerWhile		#loop back again till g_index > 3

		inR:
			lw $t0, r_index
			addi $t0, $t0, 1
			sw $t0, r_index
			j outterWhile		#loop back again till r_index > 3
	
		endResult:
			jr $ra
			#display the number of bull
		#	li $v0, 1
		#	lw $t4, bull
		#	move $a0, $t4
		#	syscall
		#
		#	li $v0, 4
		#	la $a0, bullPrint
		#	syscall
		#
		#	li $v0, 1
		#	lw $t4, cow
		#	move $a0, $t4
		#	syscall
		#
		#	li $v0, 4
		#	la $a0, cowPrint
		#	syscall
		#
		#	#end Line
		#	li $v0, 4
		#	la $a0, endl
		#	syscall
