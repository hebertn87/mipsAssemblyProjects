#******************************************************************************************************
#Nathan Hebert 4/8/17
#This program will allow a user to implement and manage a list of items that are dynamically allocated.
#******************************************************************************************************

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
	
	li	$v0, 9			#Allocates dynamic memory
	la	$a0, 4			#for the head pointer
	syscall				#and executes
	
	move	$s0, $v0		#Moves the address into $so
	sw 	$0, 0($s0)		#Gets rid of the garbage in the address/makes it null
	
	li	$v0, 4			#Sets the return value to string
	la	$a0, welcome		#And ouputs the string welcome
	syscall	
	
	jal	menu			#Jumps to the menu procedure
	
	li	$v0, 4			#Loads return value into string
	la	$a0, exit		#Loads string into arugment
	syscall				#and executes it
	
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	jr	$ra			#Passes back control to previous procedure
	
#*******************************************************
#Procedure frame that contains the menu for the program.
#%Param%
#%$s3 = counter for number of items
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
	beq	$v0, 2, removejal	#If the value in $v0 is 2, jump to remove procedure
	beq	$v0, 3, displayjal	#If the value in $v0 is 3, jump to display procedure
	beq	$v0, 4, endmenu		#If the value in $v0, is 4, jump to endmenu label
	j	endmenu			#If another value is put in, other than 1-4, still exit.
	
#Performs a jal to input procedure
inputjal:
	jal	input			#Jumps and links to input
	j	menuloop		#Jump back up to menuloop

#Performs a jal to remove procedure	
removejal:
	jal	remove			#Jumps and links to remove
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

#******************************************************************
#This procedure frame allows the user to input an item to the list.
#Process: Gets an integer value, allows the user to input.
#Dynamically allocates space for the value, and 
#%Param:%
#%$t0 = Integer value, $t1 = index value, $t2 = contains head, 
#%$t3 = index position, $t4 = counter for traverse.
#******************************************************************
input:	
	addi	$sp, $sp, -32		#Implements the procedure frame
	sw	$fp, 16($sp)		#Allocates stack, and saves
	sw	$ra, 20($sp)		#Both $ra and $fp
	addi	$fp, $sp, 28		#Set frame pointer 4 bytes below top of stack
	sw	$s3, 24($sp)		#store $s3, the item count, onto stack
	
	move	$t2, $s0		#Move the head pointer into $t2
	li	$t4, 0			#Load 0 into $t4, the value of the counter for traverse
		
	li	$v0, 4			#Loads return to type string
	la	$a0, in			#Loads in arugment the string 
	syscall				#And executes it
	
	li	$v0, 5			#Loads integer input into return
	syscall				#And executes it
	
	move	$t0, $v0		#Moves the inputed value into arugement
	
	li	$v0, 4			#move the return value to type string
	la	$a0, index		#Move string  index into argument
	syscall				#and exectues it
	
	li	$v0, 5			#Moves input integer into return
	syscall				#and execute
	
	move	$t1, $v0		#Move the index number into $t1
	
	la	$a0, 8			#allocates 8 bytes, the amount needed for an item
	li	$v0, 9			#Allocates a block of memory
	syscall				#and executes it
	
#Traverse the linked list till you find where you want to input
traverseadd:
	lw	$t3, 0($t2)		#Load the value of the address of the next 
	beq	$t3, $0, addend		#If the value of the address is null, jump to addend
	beq	$t4, $t1, addmid	#If the value of the counter is equal to the counter of the traverse jump to addmid
	move	$t2, $t3		#Move the value of the value of the next node into $t2
	add	$t4, $t4, 1		#Increment the traverse counter
	
	j	traverseadd		#jump to traverse 
		
#If the index is not at the end, input it at the specified index	
addmid:	
	lw	$t3, 0($t2)		#Load the value of the next address/node
	sw	$v0, 0($t2)		#Moves stores the new value into $t1
	sw	$t3, 0($v0)		#Move the value stored in next address to 0 bytes off $v0
	sw	$t0, 4($v0)		#store the value of the integer in the next spot
	move	$t2, $t3		#Move the value next address into $t2, effectively moving to next
	
	j	endinput		#Jump to end of the loop
	
#If the indes is at the end, put it there			
addend:	
	sw	$v0, 0($t2)		#store the address of the memory into 0th byte offset into $t2
	sw 	$0,  0($v0)		#Set the bytes to 0 and effectively null
	sw	$t0, 4($v0)		#store the value of the int into byte offset of the address

#End of input procedure, once traversal is done, jump to end
endinput:	
	lw	$s3, 24($sp)		#restores $s3
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	addi	$s3, $s3, 1		#increment the list counter
	
	jr	$ra			#Jumps back to menu
		
#***************************************************
#This procedure frame removes an item from the list.
#Pick the index to remove. If the remove is in the
#List remove it, if not return error
#***************************************************
remove:
	addi	$sp, $sp, -32		#Implements the procedure frame
	sw	$fp, 16($sp)		#Allocates stack, and saves
	sw	$ra, 20($sp)		#Both $ra and $fp
	addi	$fp, $sp, 28		#Set $fp 4 bytes below top of stack
	sw	$s3, 24($sp)		#Store $s3
	
	move	$t2, $s0		#Move the value of head into $t2
	li	$t4, 0			#Move set $t4 to 0
	
	li	$v0, 4			#Sets return value to type string
	la	$a0, disprem		#Set argument to string
	syscall				#Execute syscall
	
	li	$v0, 5			#Load input integer into return 
	syscall				#Execute syscall
	
	move	$t1, $v0		#Move integer value into $t1
	
#Traverse till you find item to delete
remloop:
	lw	$t3, 0($t2)		#Load the value of the address of the next 
	beq	$t4, $t1, removeitem	#If the value of the counter is equal to the index of the value input, jump to removemid
	move	$t2, $t3		#Move the value of the value of the next node into $t2
	add	$t4, $t4, 1		#Increment the traverse counter
	
	j	remloop			#jump to traverse
	
#Procedure to remove item from mid
removeitem:
	move	$t4, $t2		#Move the address pointing to the previous node into $t5
	move	$t2, $t3		#Move the value of the value of the next node into $t2
	lw	$t3, 0($t2)		#Load the next address into $t3
	sw	$t3, 0($t4)		#Store the next address into $t5
		
	j	endrem			#Jump to endrem

#Jump to the end of the remove to end the procedure for remove
endrem:	
	lw	$s3, 24($sp)		#restores $s3
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	addi	$s3, $s3, -1		#Decrement item counter
	
	jr	$ra			#Jump back to menu loop
	
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
	
	move	$t4, $s3		#Move the index number into a temp value
	move	$t2, $s0		#Move the head address into $t2
		
	li	$v0, 4			#Loads return to type string
	la	$a0, disp		#Loads out string into arguement
	syscall				#and outputs it
	
#Traversal loop, which covers displaying all values.
traverse:
	lw	$t3, 0($t2)		#Load the value of the address of the next 
	beq	$t4, $0, endisp		#If the value of the address is null, jump to end
	move	$t2, $t3		#Move the value of the value of the next node into $t2
	add	$t4, $t4, -1		#Increment the traverse counter
	
	li	$v0, 1			#Load the return to ouput int
	lw	$a0, 4($t2)		#Load the word of the 4th byte to 1
	syscall				#Execute
	
	li	$v0, 4			#Load the return value to string
	la	$a0, space		#Load the argument with string
	syscall				#Execute syscall
	
	j	traverse		#jump to traverse 

#Once traversal is done, jump to end		
endisp:		
	lw	$s3, 24($sp)		#Restore $s3
	lw	$ra, 20($sp)		#Restores $ra
	lw	$fp, 16($sp)		#Restores $fp
	addi	$sp, $sp, 32		#Restores $sp
	
	jr	$ra			#Passes control back to previous frame
	
#****************
#Section for data
#****************
	.data
welcome:	.asciiz "Welcome. This program allows you add, remove, and display items in a list of integers."
dispmenu:	.asciiz "\nPlease input an integer based on whch instruction you wish to perform.\n*******************\n*      Menu       *\n* 1. Input item   *\n* 2. Remove item  *\n* 3. Display List *\n* 4. Exit         *\n*******************\nPlease choose an item: "
disp:		.asciiz "\nYour list currenty contains: \n"
in:		.asciiz "\nPlease input the integer you wish to input into the list: " 
index:		.asciiz "\nPlease enter a specified index (0 is the first index): "
disprem:	.asciiz "\nPlease specify the index of the item you wish to remove: "
space:		.asciiz " "
exit:		.asciiz "\nThis program will now exit. Goodbye."