#Nathan Hebert
#Project 1, 2/2/17
#This MIPS code will output a hellow world statement
	.data
	
	str:	.asciiz	"\nHello World!\n"		#string
	
	
	.text
main: 
		li $v0, 4				#adds the word size to $v0
		la		$a0, str		#loads address of the string
		syscall					#calls output from $v0
		
		li 		$v0, 10			#exit
		syscall