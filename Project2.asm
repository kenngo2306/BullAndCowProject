.data
	dict: 				.asciiz "zoicfoxyjawszipszingbruxcalxvextminxfauxoyezjogsquodcruxjagsjoysquinjudozigszagsgazebucklynxjoshjoeyhazepuckplexjigsquizjeuxjinxjockjackjumpjambjokyjivyjunkjimpjaukphizzoukzonkjukechezcozyzymemazyjoukqophjinkwhizfozyjokejakezebufujijowlpujajerkjaupjivejaggzeksjupefuzeputzhazykojizincfutzjubazerkjucojubequipwaxyjehujugsjowsdozylazyfluxmazeczarfazepixyjohnboxyjibejugajibsbizejuryjobsprezjabsfrizjapepoxyzepsjamsquayzanyyutzzapsqueyzarfquaghadj"
	correct_word: 		.space 4									# used to store correct word
	random_number: 		.word 4										# used to store random number
	random_max_value: 	.word 110									# used to set max number of word
	welcome_message:		.asciiz "Welcome to Bulls & Cows!\nMake 4 letter guesses to determine the hidden word"
	bullPrint:			.asciiz "\nBulls: "
	cowPrint:			.asciiz "\nCows: "
	input:				.asciiz "\n\nGuess #"
	inputColon:				.asciiz ":"
	invalid_msg:			.asciiz "\nInput was invalid, please only enter letters."
	endl:				.asciiz "\n"
	guess_word_index:			.word 0										# get the next index
	correct_word_index:			.word 0										# count the correct_word_index till it reaches 4 then ends
	end_word_index:				.word 0
	bull: 				.word 0
	cow:				.word 0
	guessCount: 			.word 0
	.align 2 
	guess:				.space 5
	time:				.word 0
	second:				.asciiz " (s)\n"
	.align 2 
	end_signal:			.ascii "!END"
.text

	  ## generate random number and get a random word from dictionary
	 	jal generate_random_number							# get random number from 1 to 110 from $v0
 		sw $v0, random_number								# store random number return from function
 		jal get_correct_word_from_random_number				# get correct word in dict from random_number
 	
 		la $a0 , correct_word	#TO-DO: swap "correct_word" with "welcome_message"
 		li $v0, 4
 		syscall
 	  ################## end of generate random word ############################
 	  # get the starting time
	  		li $v0, 30
	  		syscall
	  		sw $a0, time

 	  main:
 	  # get input from user
			li $v0, 4 #Prints "Guess #"
			la $a0, input
			syscall
			
			lw $t0, guessCount #Adds 1 to the number of guesses
			addi $t0, $t0, 1
			sw $t0, guessCount 
			
			li $v0, 1 #Prints Number of guesses before colon
			move $a0,$t0
			syscall
			
			li $v0, 4 #Prints out colon
			la $a0, inputColon
			syscall
	
			#get string
			li $v0, 8
			la $a0, guess
			li $a1, 5
			syscall

 	  # validation code goes here					
 	  	#### Sean's code ####
			la	$t9, guess
			lw	$t1, ($t9)		# t9 is now the entire read word
			lw	$t0, end_signal
			beq	$t0, $t1, exit		# If the word is the end signal, exit.
			addi	$t8, $t9, 4
		validloop:
				lb	$t0, ($t9)
				slti	$t1, $t0, 65 		# A
				li	$t2, 90 		# Z
				sgt	$t2, $t0, $t2
				or	$t1, $t1, $t2		# Is wchar between A and Z inclusive? i.e. is it capitalized?
				bne	$t1, $zero, next	# If yes...
				addi	$t0, $t0, 32 		# ...Upper to lower case
			next:
				slti	$t1, $t0, 97 		# a
				li	$t2, 122		# z
				slt	$t2, $t2, $t0
				or	$t1, $t1, $t2		# Is wchar between a and z inclusive? i.e. was it a letter?
				bne	$t1, $zero, invalid	# If it wasn't a valid letter, go somewhere to print an error message.
				sb	$t0, ($t9)
				
				#checking  for byte done, loop:
				
				addi	$t9, $t9, 1		# Increment the byte being read by 1
				bne	$t8, $t9, validloop	# If the byte position is longer than the guess, we're finished.
			
			
		# call bull and count if validation is success
		# play sound
		jal success_sound
		
		# print bull and cow
		jal count_bulls_and_cows
		
		# print bull
		li $v0, 4
		la $a0, bullPrint
		syscall
		lw $a0, bull
		li $v0, 1
		syscall
	
		# print cow
		li $v0, 4
		la $a0, cowPrint
		syscall
		lw $a0, cow
		li $v0, 1
		syscall
		
		#reset and loop back
		lw $t1, bull
		beq $t1, 4, exit
		
		lw $t1, cow
		add $t1, $zero, $zero
		sw $t1, cow
		
		lw $t1, bull
		add $t1, $zero, $zero
		sw $t1, bull
		
		lw $t1, guess_word_index
		add $t1, $zero, $zero
		sw $t1, guess_word_index
		
		lw $t1, correct_word_index
		add $t1, $zero, $zero
		sw $t1, correct_word_index
		
		j main
		
	invalid:
		li $v0, 4
		la $a0, invalid_msg
		syscall
		j main
		
		exit:
			li $v0, 4
			la $a0, endl
			syscall
		
			li $v0, 30
			syscall
			
			# print time (in second)
			lw $t1, time
			sub $t1, $a0, $t1
			div $t1, $t1, 1000
			sw $t1, time
		
			lw $a0, time
			li $v0, 1
			syscall
		
			li $v0, 4
			la $a0, second
			syscall
			
			#print the correct word
			la $a0 , correct_word
 			li $v0, 4
 			syscall
		
			#end
			li $v0, 10											# end of main, below of this code are all functions
			syscall

###################################################################################################################################
##																																 ##
##													FUNCTIONS SECTION															 ##
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
 	
 	######### count bulls and cows function ###########	
 	count_bulls_and_cows:
		outterWhile:
			lw $t1, correct_word_index					#t1 = correct_word_index
			bgt $t1, 3, endResult						#Finish condition (when correct_word_index actually >3)
			#lw $t0, guess_word_index
			add $t0, $zero, $zero						#reset guess_word_index to zero before loop through innerWhile
			sw $t0, guess_word_index

		innerWhile:
			lw $t0, guess_word_index					#t0 = guess_word_index
			lw $t1, correct_word_index					#t1 = correct_word_index
	
			bgt $t0, 3, inR								#increment correct_word_index
	
			bne $t0, $t1, cowEqual						#if the 2 index dont match -> check for cow

			la $t0, correct_word
			la $t1, guess
	
			lw $s0, correct_word_index
			lw $s1, guess_word_index
	
			#compare the 2 letter at index of correct word and index of guessed word 
			addu $t0, $t0, $s0
			lbu $t2, ($t0)
	
			addu $t1, $t1, $s1
			lbu $t3, ($t1)
	
			#if they are equal and by last condition of the 2 index being equal -> bull
			beq $t2, $t3, bullEqual
			j inG										#increment guess_word_index
	
		bullEqual:
			lw $t0, bull
			addi $t0, $t0, 1
			sw $t0, bull
			j inG

		cowEqual:										#when the correct_word_index != guess_word_index -> go here
			la $t0, correct_word
			la $t1, guess
			lw $s0, correct_word_index
			lw $s1, guess_word_index
	
			addu $t0, $t0, $s0
			lbu $t2, ($t0)
	
			addu $t1, $t1, $s1
			lbu $t3, ($t1)
	
			beq $t2, $t3, cowEqual2						#condition if the 2 index actual equal -> cow +1
			j inG

		cowEqual2:
			lw $t1, cow
			addi $t1, $t1, 1
			sw $t1, cow
	
		inG:
			lw $t0, guess_word_index
			addi $t0, $t0, 1
			sw $t0, guess_word_index
			j innerWhile								#loop back again till guess_word_index > 3

		inR:
			lw $t0, correct_word_index
			addi $t0, $t0, 1
			sw $t0, correct_word_index
			j outterWhile								#loop back again till correct_word_index > 3
	
		endResult:
			jr $ra										# jump back to main
			
		
	jumpBack:
		lw $t1, end_word_index
		add $t1, $zero, $zero
		sw $t1, end_word_index
		
		lw $t1, guess_word_index
		add $t1, $zero, $zero
		sw $t1, guess_word_index
		
		jr $ra
	########## end count bull and cow function ##################
