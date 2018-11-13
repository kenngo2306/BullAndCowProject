.data
	dict: 				.asciiz "zoicfoxyjawszipszingbruxcalxvextminxfauxoyezjogsquodcruxjagsjoysquinjudozigszagsgazebucklynxjoshjoeyhazepuckplexjigsquizjeuxjinxjockjackjumpjambjokyjivyjunkjimpjaukphizzoukzonkjukechezcozyzymemazyjoukqophjinkwhizfozyjokejakezebufujijowlpujajerkjaupjivejaggzeksjupefuzeputzhazykojizincfutzjubazerkjucojubequipwaxyjehujugsjowsdozylazyfluxmazeczarfazepixyjohnboxyjibejugajibsbizejuryjobsprezjabsfrizjapepoxyzepsjamsquayzanyyutzzapsqueyzarfquaghadj"
	correct_word: 		.space 4									# used to store correct word 
	random_number: 		.word 4										# used to store random number
	random_max_value: 	.word 110									# used to set max number of word
	bullPrint:			.asciiz "\nBull= "
	cowPrint:			.asciiz "\nCow= "
	#result:				.asciiz "NOAR"								# assigned word
	input:				.asciiz "\nGet input: "
	buffer:				.space	36
	endl:				.asciiz "\n"
	guess_word_index:			.word 0										# get the next index
	correct_word_index:			.word 0										# count the correct_word_index till it reaches 4 then ends
	bull: 				.word 0
	cow:				.word 0
	guess:				.asciiz										# holds the input of the user
	inp:				.space 5
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
 	  
 	  #The rest of this needs to be on a loop, right?
 	  
 	  # get input from user
 			#print out "Get input: "
			li $v0, 4
			la $a0, input
			syscall
	
			#get string
			li $v0, 8
			la $a0, buffer
			li $a1, 5
			syscall
			move $t1,$a0 	#save string to t0
			sw $t1, guess	#This needs to be recoded, it just copies the address of the buffer to guess.
					#Saving the guess may not even be required
 	  	
 	  # validation code goes here					
 	  	#### Sean's code ####
			li	$t8, 0			# Potential problem: code reads bytes from most to least significant.
			# li	$t8, 24			# If the syscall reads them the other way, it can be reverse by using
							# the commented assembly.
			li	$t7, 32
			lw	$t9, buffer		# t9 is now the entire read word
			srl	$t0, $t9, 24		# $t0 is the working char, wchar
			# sllv	$t0, $t9, $t8
			# srl	$t0, $t0, 24
			li	$t1, 33 		# if it is ! ...
			beq	$t0, $t1, giveup	# ... it might be !END, so jump to giveup.
		validloop:
				slti	$t1, $t0, 65 		# A
				li	$t2, 90 		# Z
				slt	$t2, $t2, $t0
				and	$t1, $t1, $t2		# Is wchar between A and Z inclusive? i.e. is it capitalized?
				bne	$t1, $zero, next	# If yes...
				addi	$t0, $t0, 32 		# ...Upper to lower case
				slti	$t0, $t1, 97 		# a
				li	$t2, 122		# z
				slt	$t2, $t2, $t0
				and	$t1, $t1, $t2		# Is wchar between a and z inclusive? i.e. was it a letter?
				beq	$t1, $zero, invalid	# If it wasn't a valid letter, go somewhere to print an error message.
				
				#checking  for byte done, loop:
				
				addi	$t8, $t8, 8		# Increment the byte being read by 1
				# addi	$t8, $t8, -8
				sllv	$t0, $t9, $t7		# remove left bytes
				srl	$t0, $t0, 24		# remove right bytes and align
				bne	$t8, $t7, validloop	# If $t8 was 32, no byte was read and we're done. Otherwise, loop.
			
			
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
			lw $t1, guess
	
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
			lw $t1, guess
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
	########## end count bull and cow function ##################
