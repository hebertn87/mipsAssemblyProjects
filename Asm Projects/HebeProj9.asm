#************************************************************************
#Nathan Hebert 4/8/17
#This program will allow a user to implement and manage an array of items
#************************************************************************

#*****************
#Section for text.
#*****************
	.text
#*********************************************************************
#This is the main procedure, which handles the control of the program.
#*********************************************************************
main:
	addi	$sp, $sp, -32		#Implements the procedure frame
	sw	$fp, 16($sp)		#Allocates stack, and saves
	sw	$ra, 20($sp)		#Both $ra and $fp
	addi	$fp, $sp, 28		#Set $fp 4 bytes below top of stack
	
	li	$v0, 4			#Sets the return value to string
	la	$a0, welcome		#And ouputs the string welcome
	syscall	
	
	jal	initial			#Initializes the array
	
	jal	menu			#Jumps to the menu procedure
	
	li	$v0, 4			#Loads return value into string
	la	$a0, exit		#Loads string into arugment
	syscall				#and executes it
	
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	jr	$ra			#Passes back control to previous procedure
	
#***************************************************
#Procedure frame that contians the input for program
#***************************************************
initial:
	li	$v0, 4
	la	$a0, initialize
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0
	
	li	$v0, 4
	la	$a0, cols
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s1, $v0
	
	li	$v0, 9			#Allocates dynamic memory
	la	$a0, ($s0)		#for the head pointer
	syscall				#and executes

	move	$s2, $v0		#Moves the address into $so
	sw 	$0, 0($s2)		#Gets rid of the garbage in the address/makes it null

initialoop:
	beq	$s0, 0, endinitial	
	li	$v0, 9	
	la	$a0, ($s1)
	syscall
	
	sw	$a0, 0($s2)
	addi	$s2, $s2, 4
	addi	$s0, $s0 -1
	
endinitial:	
	jr	$ra
	
#*******************************************************
#Procedure frame that contains the menu for the program.
#*******************************************************	
menu:
	addi	$sp, $sp, -32		#Implements the procedure frame
	sw	$fp, 16($sp)		#Allocates stack, and saves
	sw	$ra, 20($sp)		#Both $ra and $fp
	addi	$fp, $sp, 28		#Set $fp 4 bytes below top of stack
	
	li	$s3, 0			#Set counter value for number of items
	
menuloop:	
	li	$v0, 4			#Loads the return value as a string
	la	$a0, dispmenu		#Load string inputstr in to argument
	syscall				#and executes it
	
	li	$v0, 5			#loads the value in return to input integer
	syscall				#And executes it
	
	beq	$v0, 1, inputjal	#if the value in $v0 is 1, jump to input procedure
	beq	$v0, 3, displayjal	#If the value in $v0 is 3, jump to display procedure
	beq	$v0, 4, endmenu		#If the value in $v0, is 4, jump to endmenu label
	j	endmenu			#If another value is put in, other than 1-4, still exit.
	
#Performs a jal to input procedure
inputjal:
	jal	input			#Jumps and links to input
	j	menuloop		#Jump back up to menuloop

#Performs a jal to display procedure	
displayjal:
	jal	display			#Jumps and links to disply
	j	menuloop		#Jump back up to menuloop

#Once end of the menu is chosen, restore and pass back control to previous procedure	
endmenu:	
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	jr	$ra			#Passes back control to the previous procedure

#**************************************************************
#This procedure frame allows the user to input items into array
#Process: Gets an integer value, allows the user to input.
#**************************************************************
input:	
	addi	$sp, $sp, -32		#Implements the procedure frame
	sw	$fp, 16($sp)		#Allocates stack, and saves
	sw	$ra, 20($sp)		#Both $ra and $fp
	addi	$fp, $sp, 28		#Set frame pointer 4 bytes below top of stack
	
	
	lw	$s3, 24($sp)		#restores $s3
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	addi	$s3, $s3, 1		#increment the list counter
	
	jr	$ra			#Jumps back to menu
		
#**********************************
#This procedure frame traverses and
#Displays the list
#**********************************
display:	
	addi	$sp, $sp, -32		#Implements the procedure frame
	sw	$fp, 16($sp)		#Allocates stack, and saves
	sw	$ra, 20($sp)		#Both $ra and $fp
	addi	$fp, $sp, 28		#Set $fp 4 bytes below top of stack
	sw	$s3, 24($sp)		#store $s3, as part of procedure call
	
	
	lw	$s3, 24($sp)		#Restore $s3
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	jr	$ra			#Passes control back to previous frame

#****************************************************
#This procedure helps to display the sum of every row
#****************************************************
sum:

		
#****************
#Section for data
#****************
	.data
welcome:	.asciiz "Welcome. This program initialize and enter integers into a 2D array."
dispmenu:	.asciiz "\nPlease input an integer based on whch instruction you wish to perform.\n********************\n*      Menu        *\n* 1. Input item    *\n* 2. Remove item   *\n* 3. Display Array *\n* 4. Exit          *\n********************\nPlease choose an item: "
disp:		.asciiz "\nYour array currenty contains: \n"
initialize:	.asciiz "\nPlease input the rows and columns you wish to work with. Rows: " 
item:		.asciiz "\nPlease input the value you wish to store here: "
cols:		.asciiz	"\nColumns: "
index:		.asciiz "\nPlease enter a specified index (0 is the first index): "
space:		.asciiz " "
exit:		.asciiz "\nThis program will now exit. Goodbye."
