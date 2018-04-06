#*******************************************************************************************************
#Nathan Hebert 3/24/17
#This program will allow a user to input an experession, and the program will evaluate the input in
#a postfix format. Only add, subtract, multiply and divide instructions are acceptable.
#*******************************************************************************************************
	
	.data
welcome:	.asciiz "Welcome. This program allows you to input a postfix expression, and the program will evaluate it."
inputstr:	.asciiz "\nPlease input your postfix calculation: "
out:		.asciiz "\nYour answer is: "
exit:		.asciiz "\nThis program will now exit. Goodbye."

	.text
#********************************************************************
#This is the main procedure, which handles the control of the program
#********************************************************************
main:
	addi	$sp, $sp, -112	#Implements the procedure frame
	sw	$fp, 96($sp)	#Allocates stack, and saves
	sw	$ra, 100($sp)	#Both $ra and $fp
	addi	$fp, $sp, 108

	li	$v0, 4		#Sets the return value to string
	la	$a0, welcome	#And ouputs the string welcome
	syscall
	
	jal	input		#Jump to the input procedure
	
	move	$a0, $sp	#Moves the address of the string to $a0
	
	jal	calc		#Jump and link to the calc procedure
	
	move	$a0, $v0	#Moves the returned value of calc to $a0
	
	jal	display		#Jumps and links to display procedure
	
	lw	$ra, 100($sp)	#Restores the values of the procedure frame back
	lw	$fp, 96($sp)
	addi	$sp, $sp, 112
	
	li	$v0, 4		#Exit string loaded and outputted
	la	$a0, exit
	syscall

	jr	$ra		#Passes back control to previous procedure
	
#*******************************************************************************
#Procedure frame that allows the user to input the expression toe be calculated.
#*******************************************************************************	
input:
	li	$v0, 4		#Loads the return value as a string
	la	$a0, inputstr	#Load string inputstr in to argument
	syscall			#and executes it
	
	li	$v0, 8		#Loads string input into return
	move	$a0, $sp
	li	$a1, 80		#max size of the string
	syscall			#and executes it
	
	jr	$ra		#Passes back control to the previous procedure
	
#************************************************************
#This procedure calculates the value of the expression given.
#************************************************************
calc:
	addi	$sp, $sp, -112	#Implements the procedure frame
	sw	$fp, 96($sp)	#Allocates stack, and saves
	sw	$ra, 100($sp)	#Both $ra and $fp
	addi	$fp, $sp, 108
	
	move	$t1, $sp	#Moves the address of the new stack to $t1

#Loop for the iteration 	
loop:
	lb	$t0, 0($a0)	#Load the byte of the first address
	
	beq	$t0, 10, end	#If the string hits a null, end
	beq	$t0, '+', addp	#If the value is a plus, jump to addition
	beq	$t0, '-', subp	#If the bit is a subtract, jump to subtract
	beq	$t0, '*', mulp 	#If the bit is an asterisk, jump to multiply
	beq	$t0, '/', divp	#if the bit is a /, jump to divide
	
	add	$t0, $t0, -48	#Set the value of ascii to decimal int value
	sw	$t0, 0($t1)	#tore the value in $t0 on the stack
	addi	$t1, $t1, 4	#Add word size
	
	j	shift		#Jumps to the shift step
	
#Take 2 number off stack, add them	
addp:
	
	lw	$t2, -4($t1)	#Loads the byte that is -4 to $t2
	lw	$t3, -8($t1)	#Loads the byte that is -8 to $t3
	add	$t2, $t3, $t2	#Adds the values given and puts it back into $t2
	
	j	next		#Jumps to next label
		
#Take 2 numbers off stack sub them
subp:
	
	lw	$t2, -4($t1)	#Loads the byte that is -4 to $t2
	lw	$t3, -8($t1)	#Loads the byte that is -8 to $t3
	sub	$t2, $t3, $t2	#Subtract the values and put it in $t2
	
	j	next		#Jumps to next label

#Take 2 numbers off stack, mul them
mulp:
	
	lw	$t2, -4($t1)	#Loads the byte that is -4 to $t2
	lw	$t3, -8($t1)	#Loads the byte that is -8 to $t3
	mul	$t2, $t3, $t2	#Multiplies the value and put it into $t2
	
	j	next		#Jumps to next label
	
#Take 2 numbers off stack, div them
divp:

	lw	$t2, -4($t1)	#Loads the byte that is -4 to $t2
	lw	$t3, -8($t1)	#Loads the byte that is -8 to $t3
	div	$t2, $t3, $t2	#divide the values and put it into $t2
	
	j	next		#Jumps to next label
		
#Stores back onto the stack and decrements by 4
next:
	addi	$t1, $t1, -4	#subtract the word size to $t1
	sw	$t2, -4($t1)	#Store the word from $t2 into $t1

#increments by the word size and 
shift:
	addi	$a0, $a0, 1	#Increment $a0 address by word size
	
	j	loop		#Jump back up to loop

#Once the program is done iterating, jump end	
end:
	lw	$v0, -4($t1)	#Loads the value contained -4 from $t1, and store in $v0
	
	lw	$ra, 100($sp)	#Restores the values of the procedure frame back
	lw	$fp, 96($sp)
	addi	$sp, $sp, 112

	jr	$ra		#Passes back control to previous reg
	
#**********************************************************
#This procedure frame displays the value of the expression.
#**********************************************************
display:
	move	$t0, $a0	#moves the arguement to temp reg
	
	li	$v0, 4		#Loads return to type string
	la	$a0, out	#Loads out string into arguement
	syscall			#and outputs it
	
	li 	$v0, 1 		#Loads the return to type int
	move	$a0, $t0	#Loads the $t0 into argument
	syscall			#and outputs it
	
	jr	$ra		#Passes control back to previous frame