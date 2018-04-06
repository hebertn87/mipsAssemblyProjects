#Nathan Hebert
#2/13/2017
#This program takes a character array containing numbers, and returns the integer values they represent

	.data
	
welcome: 	.asciiz "Welcome. This program will take a and report it as a number. Here is the array:\n"
array: 		.asciiz "12476498"
convertmsg:	.asciiz "\nI will now convert this to an integer.\n"
newint:		.asciiz	"Here is the new Integer\n"
errorm:		.asciiz "This code was unable to assemble. Please try again\n"	
	
	.text
	
main:	

	li 	$v0, 4			#Output welcome message to console
	la	$a0, welcome
	syscall 
		
	la	$a0, array		#Output Array to console
	syscall
	
	la	$a0, convertmsg		#Convert message string
	syscall				
	
	la	$s1, array		#Load address of the array into
	jal	str2int			#Jump and link to str2int procedure
	
	la	$a0, newint		#New int string and output it to console
	syscall				
	
	li	$v0, 1			#Print string number into return
	la	$a0, ($s2)		#Load address of int into argument and output
	syscall
					
	li	$v0, 10			#Exit
	syscall


str2int: 
	
	lbu	$t1, ($s1)		#Loads the first byte of string into temp	
	
	beq	$t1, $0, end		#Branch if $t1 contains null
	blt	$t1, 48, error   	#Branches on less than, because it makes more sense
  	bgt 	$t1, 57, error		#or branches on greater than if if the value is not an integer

	addi 	$t1, $t1, -48		#Minuses the byte offset of ascii to the number, to get a value between 0 and 9
	mul 	$s2, $s2, 10  		#Multiplies by 10, to add a digit to a new column
 	add	$s2, $s2, $t1    	#Adds the number to the multiple of 10, keeping our number the same
	addi	$s1, $s1, 1		#incrememnt the number by one
	
	j	str2int			#Loop back to beginning of str2int
	
end:
	jr  	$ra			#Pass back control to main
   
error:
	
	la	$a0, errorm		#Error Message output
	syscall				#output error message
	
 	li 	$v0, 10			#Exit
 	syscall