#Nathan Hebert	2/21/2017
#This program performs the towers of hanoi simulation

	.globl main
	.data
	
welcome: 	.asciiz "Welcome. This program will simulate the towers of Hanoi. \nPlease enter how many discs you want to work with.\n"
direction1:	.asciiz	"\nMove Disk "
direction2:	.asciiz " from Pole "
direction3:	.asciiz	" To Pole "
done:		.asciiz "\nDone. The program will now exit\n"
src:		.asciiz "A"
dest:		.asciiz "B"
spare:		.asciiz "C"

	.text
	
main:
	li $v0, 4		#Welcome Message Output
	la $a0, welcome
	syscall 
	
	li $v0, 5		#Input an integer into $a0
	syscall
	
	move $s0, $v0	
	la $a1, src		#$a1 = source			
	la $a2, dest	#$a2 = dest
	la $a3, spare	#4a3 = spar

	jal towers		#Jump and link to towers section
	
	li $v0, 4		#Changes return to int
	la $a0, done		#Loads done message
	syscall			#And returns it
	
	li $v0, 10 		#exit
	syscall
	
towers:	
	slti $t1, $s0, 1	#Set's temp1 to 1 if if n is less than 1
	beq $t1, 1, end		#If n is less than one, exit
	
	add $sp, $sp, -32	#Allocate 32 bytes of memory
	sw $ra, 0($sp)		#Store RA in stack
	sw $s0, 4($sp)		#Store n to stack
	sw $a1, 8($sp)		#Store source to stack
	sw $a2, 12($sp)		#Store dest to stack
	sw $a3, 16($sp)		#Store spare to stack
	
	addi $s0, $s0, -1	#Decrement by 1
	
	move $t1, $a3		#Moves spare to temp
	move $a3, $a2		#Moves dest to spare
	move $a2, $t1		#Moves move spare to dest

	jal towers		#Jumps to towers	

	lw $ra, 0($sp)		#reload from stack ra
	lw $s0, 4($sp)		#reload s0 from stack
	lw $a1, 8($sp)		#reload a1 from stack
	lw $a2, 12($sp)		#reload a2 from stack
	lw $a3, 16($sp)		#reload a3 from stack
	add $sp, $sp, 32	#change stack 32 bytes
	

	li $v0, 4		#Load return to string type
	la $a0, direction1	#Load our first string
	syscall			#and outputs it
	
	la $v0, 1		#Loads return type to int
	la $a0, ($s0)		#Loads n into disk
	syscall			#and outputs it
	
	li $v0, 4		#Changes return back to string
	la $a0, direction2	#Loads second string
	syscall			#and outputs it
	
	la $a0, ($a1)		#Loads first pole
	syscall			#And outputs it
	
	la $a0, direction3	#Loads 3rd string
	syscall			#and outputs it
	
	la $a0, ($a2)		#Loads second pole
	syscall			#and outputs it
	
	add $sp, $sp, -32
	sw $ra, 0($sp)		#Store RA in stack
	sw $s0, 4($sp)		#Store n to stack
	sw $a1, 8($sp)		#Store source to stack
	sw $a2, 12($sp)		#Store dest to stack
	sw $a3, 16($sp)		#Store spare to stack
	
	move $t1, $a1		#Move souce to a temp
	move $a1, $a3		#Move spare to source
	move $a3, $t1		#move source to spare
	
	addi $s0, $s0, -1	#Decrement s0 by 1
	
	jal towers		#Recursive go back
	
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 32	#restore stack pointer
	
	jr $ra			#jump to last register
	
end: 
	jr $ra			#jump back to main using end condition
	