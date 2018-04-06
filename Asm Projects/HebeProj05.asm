#***********************************************************************************
#Nathan Hebert 3/20/17
#This program simulates the multiply instruction used in standard MIPS opersations
#It takes 2 unsigned integers, multiplies them, and returns the product.
#***********************************************************************************

	.data
welcome: 	.asciiz	 "Welcome. This program will allow you to multiply to positive numbers together. \nPlease enter your first integer: "  
second:		.asciiz	 "\nPlease enter your second number: "
product:	.asciiz	 "\nThe product is: "

	.text
#*****************************************************************************
#This is the main procedure frame, which will handle the input of the integers
#*****************************************************************************
main:
	addi	$sp, $sp, -32	#Implements the procedure frame
	sw	$fp, 0($sp)	#Allocates stack, and saves
	sw	$ra, 4($sp)	#Both $ra and $fp
	addi	$fp, $sp, 28
	
	jal	input		#Jumps to input which allows you to input two numbers
	move	$a0, $v0	#Moves the returned values,
	move	$a1, $v1	#$v0 and $v1, to argument registers
	
	jal	multi		#Takes the numbers input and multiply it
	move 	$a0, $v0	#Moves the returned value product to argument
	jal	display		#Jumps to display, to output the product
		
	lw	$ra, 4($sp)	#Restores the values of the procedure frame back
	lw	$fp, 0($sp)
	addi	$sp, $sp, 32

	jr	$ra		#Returns control back to qtspim main
	
#****************************************************************
#Procedure frame that allows you to input two numbers to multiply
#****************************************************************
input:
	li	$v0, 4		#Output welcome message to console
	la	$a0, welcome
	syscall 
	
	li	$v0, 5		#Input an integer into $v0
	syscall
	move	$t0, $v0	#Move input into $s0
	
	li	$v0, 4		#Outputs second input message
	la	$a0, second
	syscall
	
	li	$v0, 5		#Input an integer into $v0
	syscall
	move   	$t1,$v0		#Move input into $s1
	
	move	$v0, $t0	#moves the values stored back into
	move	$v1, $t1	#return registers
	
	jr	$ra		#Restores control back to last procedure frame
	
#********************************************************************************************
#procedure frame performs the main operations for multiplying and outputting the product
#********************************************************************************************	
multi:
	addi 	$sp, $sp, -32	#Allocates procedure call convention
	sw	$fp, 0($sp)	#stores $fp and $ra, and 
	sw	$ra, 4($sp)	#sets $fp and allocates 32 bits
	addi	$fp, $sp, 28
	
	move	$t0, $a0	#Loads the multiplier
	move	$t1, $a1	#Loads the multiplicand
	move 	$t2, $0       	#Extra 32 bits for the product
	li	$t3, 32		#Counter for passes through set to 32	

#This label iterates the loop until our counter of is iterated 32 times	
loop:
	beq	$t3, 0, exit	#If the counter is 0, exit
	sll	$t4, $t0, 31	#shift left
	srl	$t4, $t4, 31	#then shift right to isolate the bit
	beq	$t4, $0, skip	#If the bit is 0, skip the add step
	
	add	$t2, $t2, $t1	#Add the multiplicand to the product
	
#This label skips the add instruction since the bit was 0
skip:
	sll	$t4, $t2, 31	#Shift the product to the left, and store it
	srl	$t2, $t2, 1	#shift the prdouct right one
	srl	$t0, $t0, 1	#shift the multiplier right one
	addu	$t0, $t0, $t4	#Add the newly stored final bit of the product to the multiplier
				#effectively shifting the 64 bit number to the right
	
	add	$t3, $t3, -1	#Decrement the value by 1
	
	j	loop		#Jump back to loop
	
#This label is jumped to once the counter is 0
exit:
	lw	$ra, 4($sp)	#Restores the values of the procedure frame back
	lw	$fp, 0($sp)
	addi	$sp, $sp, 32
	
	move	$v0, $t0	#move the temp value to return
	
	jr	$ra		#Pass back control to the previous frame

#**************************************
#Procedure frame to display the Product
#**************************************
display:
	move	$t0, $a0	#Moves the argument passed to a temp value
	
	li	$v0, 4		#Ouptuts product string
	la	$a0, product
	syscall
	
	li 	$v0, 1		#Outputs the product
	move	$a0, $t0
	syscall
	
	jr	$ra		#Passes control back to previous frame