.data
	dict: .asciiz "zoicfoxyjawszipszingbruxcalxvextminxfauxoyezjogsquodcruxjagsjoysquinjudozigszagsgazebucklynxjoshjoeyhazepuckplexjigsquizjeuxjinxjockjackjumpjambjokyjivyjunkjimpjaukphizzoukzonkjukechezcozyzymemazyjoukqophjinkwhizfozyjokejakezebufujijowlpujajerkjaupjivejaggzeksjupefuzeputzhazykojizincfutzjubazerkjucojubequipwaxyjehujugsjowsdozylazyfluxmazeczarfazepixyjohnboxyjibejugajibsbizejuryjobsprezjabsfrizjapepoxyzepsjamsquayzanyyutzzapsqueyzarfquaghadj"
	correct_word: .space 4									# used to store correct word 
	random_number: .word 4									# used to store random number
	random_max_value: .word 110								# used to set max number of word
	inp:	.space 5
.text

	main:
	  ## generate random number and get a random word from dictionary
	 	jal generate_random_number							# get random number from 1 to 110 from $v0
 		sw $v0, random_number								# store random number return from function
 		jal get_correct_word_from_random_number				# get correct word in dict from random_number
 	
 		la $a0 , correct_word								# print out random word in dictionary
 		li $v0, 4
 		syscall
 	  ################## end of generate random word ############################	
 				
		#Print prompt
		li	$v0, 4
		#la	$a0, Prmpt
		syscall
		#Get input string
		li	$v0, 8
		la	$a0, inp
		li	$a1, 5
		syscall
		lb	$t0, inp
		li	$t1, 33 # !
		#beq	$t0, $t1, giveup
		slti	$t1, $t0, 97
		li	$t2, 122
		slt	$t2, $t2, $t0
		and	$t1, $t1, $t2
		#beq
	
	li $v0, 10											# end of main, below of this code are all functions
	syscall

###################################################################################################################################
##																																 ##
##													FUNCTION SECTION															 ##
##																																 ##
###################################################################################################################################
	success_sound:										# MIDI sound
		li $v0, 31
		li $a0, 72		 								# C pitch (0-127)
		li $a1, 1000 									# duration in milliseconds
		li $a2, 8										# instrument (0-127)
		li $a3, 100 									# volume (0-127)
		syscall

		li $v0, 31
		li $a0, 79		 								# G pitch (0-127)
		li $a1, 1000 									# duration in milliseconds
		li $a2, 8										# instrument (0-127)
		li $a3, 100 									# volume (0-127)
		syscall
		jr $ra
	
	generate_random_number:
		lw $a1, random_max_value  						# $a1 to the max value
    	li $v0, 42   									# generates the random number.
    	syscall
    	add $v0, $zero, $a0								# return value to $v0
    	jr $ra

    get_correct_word_from_random_number:
    	la $t0, dict									# load word list dictionary
     	lw $t5, random_number							# load the generated random number
 		sll $t5, $t5, 2 								# start of word	= random number * 4
	 	addi $t6, $t5, 4 								# end of word = start of word + 4
 		li $t7, 0										# index of correct word
 		start_loop_123:
	 		beq $t5, $t6, exit_loop_123					# loop until start = end, then exit loop
 			lb $t1, dict($t5)							# load byte from dictionary	
	 		sb $t1, correct_word($t7)					# store byte to correct word with corresponding index
 			addi $t7, $t7, 1							# increase index for correct word
 			addi $t5, $t5, 1							# increase index for start
 			j start_loop_123
 		exit_loop_123:
 		jr $ra