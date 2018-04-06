#Nathan Hebert 3/3/2017
#This program will allow a user to input a floating point number, and show its internal number as hexadecimal.

	.data

welcome: 	.asciiz "Welcome. This program will allow you to input a floating point number and the computer will show its corresponding Hexadecimal number.\n"
inputmsg:	.asciiz "\nPlease enter your floating point number: "
hex:		.asciiz	"\nHere is the number in hexadecimal form: 0x"
goodbye:	.asciiz "\nProgram ran successfully. Goodbye.\n"

	.text
	
main:
	li $v0, 4		#Output welcome message to console
	la $a0, welcome
	syscall 
	
	la $a0, inputmsg	#Input Message
	syscall				
	
	li $v0, 6		#Input an integer into $v0
	syscall			#and input to console

	addi $sp, $sp, -4	#Allocate 4 for stack
    	swc1 $f0, 0($sp)	#Save $f0 to stack
   	lw $t0, 0($sp)		#Load the value off the stack
   	addi $sp, $sp, 4	#Deallocate the stack
   	srl $t1, $t0, 28	#Shift 28 bits to right, only loading the right code to 
	
	li $v0, 4		#Change return to string 
	la $a0, hex		#Output Hex code 
	syscall 
	
	jal floathex		#Jump to floathex
	
	addi $t3, $0, 7		#Counter, for our loop, so we can determine when to end

loop:
	sll $t0, $t0, 4		#Shift the main number to the left 1
	srl $t1, $t0, 28	#shift the next digit back to where it needs to be
	
	jal floathex		#Jump to floathex
	addi $t3, $t3, -1	#decrement
	bne $t3, 0, loop	#if counter isnt 0, keep looping
				
	li $v0 4		#Change return to string
	la $a0, goodbye		#And execute it
	syscall
	
	li $v0 10		#Change return to string	
	syscall			#And execute it
	
floathex:
	bgt $t1, 9, alpha 	#Branch if the bit less than 9
	
	bltu $t1, 10, num    	#Branch if the number is greater than 10
	
finish:		
	jr    $ra		#Jump back to last register

alpha:
   	add $t1, $t1, 87   	#Add the ascii number for the first lowercase letter
   	  
    	li $v0, 11           	#Change output to character
    	la $a0, ($t1)		#and output the value
    	syscall
	
	j finish		#Jump back to finish
	
num:
	add $t1, $t1, 48  	#Add the ascii number size to the 
	    
	li $v0, 11           	#change output to character
	la $a0, ($t1)		#and output our hex bit
   	syscall
   	
   	j finish		#Jump back to finish