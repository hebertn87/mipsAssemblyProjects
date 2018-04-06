#*******************************************************************************************************
#Nathan Hebert 3/24/17
#Program approximates the value of Pi, by allowing the user to input an amount of places to approximate.
#The user can then keep going farther, or stops when the user inputs a number less than one
#*******************************************************************************************************
	
	.data
welcome:	.asciiz "Welcome. This program allows you to approximate the value of Pi to a user chosen number of accuracy."
decimal:	.asciiz "\nPlease input how to how many places after the decimal point this program should approximate to: "
pi:		.asciiz "\nHere is the approximated value of Pi: "
continue:	.asciiz "\nContinue? Please enter a number greater than or equal to one to continue. If no, please enter a number less than 1: "
exit:		.asciiz "\nThis program will now exit. Goodbye."

	.text
#********************************************************************
#This is the main procedure, which handles the control of the program
#********************************************************************
main:
	addi	$sp, $sp, -32	#Implements the procedure frame
	sw	$fp, 0($sp)	#Allocates stack, and saves
	sw	$ra, 4($sp)	#Both $ra and $fp
	addi	$fp, $sp, 28

	li	$v0, 4		#Sets the return value to string
	la	$a0, welcome	#And ouputs the string welcome
	syscall
	
redo:
	jal	input		#Jumps to the input procedure, which handles input
	move	$a0, $v0	#moves the returned value into the argument reg
	
	jal	approx		#Jumps to the approx procedure, which approximates pi
		
	jal	display		#JUmps to the display procedure, which displays pi
	
	li	$v0, 4		#sets return value to string
	la	$a0, continue	#loads string continue into argument
	syscall			#and outputs it
	
	li	$v0, 5		#sets the return to input int
	syscall
	
	addi	$t1, $0, 1	#Loads a reg with the value 1	
	slt	$t0, $v0, $t1	#Set $t0 to 1 if $a0 is less than 1
	beq	$t0, $0, redo	#Redo the loop if the value in $t0 is not less than 1
	
	li	$v0, 4		#Sets the return to string
	la	$a0, exit	#loads exit string into argument
	syscall			#and outputs it
	
	lw	$ra, 4($sp)	#Restores the values of the procedure frame back
	lw	$fp, 0($sp)
	addi	$sp, $sp, 32
	
	li	$v0, 10
	syscall
	#jr	$ra		#Passes back control to previous procedure
	
#****************************************************************************
#Procedure frame that allows the user to input the number of terms to add to.
#****************************************************************************	
input:
	li	$v0, 4
	la	$a0, decimal	#Loads decimal string into the argument
	syscall			#and outputs it
	
	li	$v0, 5		#Sets the return to input int
	syscall			#and executes it
	
	jr	$ra		#passes back control to previous procedure
	
#**************************************************************************************
#This procedure approximates the value of pi according to the number of terms requested
#**************************************************************************************
approx:
	addi	$sp, $sp, -32	#Implements the procedure frame
	sw	$fp, 0($sp)	#Allocates stack, and saves
	sw	$ra, 4($sp)	#Both $ra and $fp
	addi	$fp, $sp, 28

	move	$t0, $a0	#moves the counter value into a temp reg
	
	#****************NEED ALGORITHM FOR THIS****************#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#							#
	#*******************************************************#
	
	lw	$ra, 4($sp)	#Restores the values of the procedure frame back
	lw	$fp, 0($sp)
	addi	$sp, $sp, 32
	
	jr	$ra

#***********************************************************
#This procedure frame displays the values of Pi approximated
#***********************************************************
display:
	move	$t0, $a0	#Moves the argument passed to a temp value
	
	li	$v0, 4		#Loads return to type string
	la	$a0, pi		#Loads string pi into arument
	syscall			#and outputs it
	
	li 	$v0, 2		#Outputs pi
	syscall			
	
	jr	$ra		#Passes control back to previous frame