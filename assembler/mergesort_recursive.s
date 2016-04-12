.data
n_input_message: .asciiz "\nPlease enter here the amount of numbers that should be generated:"
min_value_input_message: .asciiz "\nPlease enter the min value of the wished data range:"
max_value_input_message: .asciiz "\nPlease enter the max value of the wished data range:"
error_message_message: .asciiz "\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n"
max_value: .word 2147483647					# max_value = 2^31 -1

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
	
	
	#... TBD: ‹bergabeparameter und co.
	
	#Logic to split the list
	
	#Recursive call of mergesort
	
	#merge all splitted parts into one list
exit_sort:

error_min_max:
	la $a0, error_message_message			# Load input message for the error message, if min is >= max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	jal main								# start program again
	
frand:
	jal rand								# Jump to rand to get random number between 0 & 2^31 - 1
	lw $t0, max_value						# load content of max_value
	mtc1 $t0, $f12							# move max_value to coprocessor
	cvt.s.w $f12, $f12 						# convert max_vaue from int to single precision float
	addi $t0, $v0, 0						# $t0 = random number from rand function
	mtc1 $t0, $f13							# load random number in coprocessor
	cvt.s.w $f13, $f13 						# convert random number from integer to floating point
	div.s $f0, $f13, $f12					# $f0 = result = random number / max_random
	j $ra									# jump back to calling function
	
	

generate_list_item:							#TBD: In die MAIN packen?
#$f12 = random_value; $f13 = min_value; $f14 = max_value
	sub.s $f4, $f14, $f13					# $f4 = max_value - min_value
	mul.s $f4, $f12, $f4 					# $f4 = random_value * (max_value - min_value)
	add.s $f0, $f13, $f4 					# $f0 = min_value + random_value * (max_value - min_value)
	j $ra									# jump back to calling function
	
main:
	la $a0, n_input_message					# Load input message for n
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5       						# read n from input  
	syscall 
	move $a1, $v0							# $a1 = n read from input
	
	la $a0, min_value_input_message			# Load input message for the min value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5      							# read min from input 
	syscall 
	move $a2, $v0							# $a1 = min read from input
	
	la $a0, max_value_input_message			# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5       						# read max from input 
	syscall 
	move $a3, $v0							# $a2 = max read from input
	
	slt $t0, $a2, $a3						# If min < max then TRUE
	beq $t0, $zero, exit_sort				# else goto exit_sort
	beq $a2, $a3, error_min_max				# If min = max goto error_min_max
	
	
	
	
	