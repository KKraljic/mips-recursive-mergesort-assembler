.data
n_input_message: .asciiz "\nPlease enter here the amount of numbers that should be generated:"
min_value_input_message: .asciiz "\nPlease enter the min value of the wished data range:"
max_value_input_message: .asciiz "\nPlease enter the max value of the wished data range:"
error_message_message: .asciiz "\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n"

.globl main
.text


recursive_merge_sort:
#$a0 =  lo; $a1 = hi; $a2 = mid; $a3 = aux; a is written on the stack by calling procedure...
	slt $t0, $a0, $a1						#If lo < hi then TRUE
	beq $t0, $zero, exit_sort
	addi $sp, $sp, -12						#decrease stackpointer to store the mid value, sp and fp
	sw $ra, 8($sp)							#save ra on the stack
	sw $fp, 4($sp)							#save fp on the stack
	#addi $fp, $sp, XXX						#set fp at the beginning of the frame TBD: Where is begin of this frame?
#Calculation of mid
	addi $t1, $t1, 2						#$t0 = 2
	add $t2, $a0, $a1						#$t1 = lo + hi
	div $a2, $a1, $t1						#$a2 = mid = (lo + hi) / 2
	sw $a2, 0($sp)							#save mid on the stack
	
	
	#... TBD: Übergabeparameter und co.
	
	#Logic to split the list
	
	#Recursive call of mergesort
	
	#merge all splitted parts into one list
exit_sort:

error_min_max:
	la $a0, error_message_message			# Load input message for the error message, if min is >= max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	jal main
	
main:
	la $a0, n_input_message					# Load input message for n
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5       						# read n from input  
	syscall 
	move $a0, $v0							# $a0 = n read from input
	
	la $a0, min_value_input_message			# Load input message for the min value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5      							# read min from input 
	syscall 
	move $a1, $v0							# $a1 = min read from input
	
	la $a0, max_value_input_message			# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5       						# read max from input 
	syscall 
	move $a2, $v0							# $a2 = max read from input
	
	slt $t0, $a1, $a2						# If min < max then TRUE
	beq $t0, $zero, exit_sort				# else goto exit_sort
	beq $a1, $a2, error_min_max				# If min = max goto error_min_max
	
	
	
	
	