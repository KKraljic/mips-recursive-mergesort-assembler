.data
#informational strings
line_break: .asciiz "\n"
n_input_message: .asciiz "\nPlease enter here the amount of numbers that should be generated:"
min_value_input_message: .asciiz "\nPlease enter the min value of the wished data range:"
max_value_input_message: .asciiz "\nPlease enter the max value of the wished data range:"
succesfully_sorted_message: .asciiz "\n Seems that everything is OK... But never trust a running system. There MUST be a bug! :D"
#error messages
error_message_message: .asciiz "\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n"
error_negative_amount_message: .asciiz "\n You tried to get a negative amount. We're not magicians. Try it again."
error_exceeded_range_message: .asciiz "\n It seems that you are not getting enough... Try it again. Smob."

#constants
const_max_value: .word 2147483647			# max_value = 2^31 -1
const_a: .word 1103515245 					# init a, value for 32bit CPU
const_b: .word 12345 # init b
const_m: .word 2147483648 # equals 2^(31)
r: .space 4

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
	j main									# start program again
	
error_negative_amount:
	la $a0, error_negative_amount_message	# Load input message for the error message, if n <= 0
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	j main									# start program again

error_exceeded_range:
	la $a0, error_exceeded_range_message	# Load input message for the error message, if {min_value; max_value} >= 2^31
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	j main									# start program again

	

# number of list items in $a0
# seed initializes an initial random r by multiplying $sp with n
seed:
# generate random r
  multu $sp,$a0   							# random_addr * n
  mflo $t0        							# random_number = random_addr * n
# input and output in $t0 - absolute value
  sra $t1,$t0,31
  xor $t0,$t0,$t1
  sub $t0,$t0,$t1
# end absolute value, in $t1 -1 after operation
  la $t1,r        							# laod address of global value r
  sw $t0, 0($t1)  							# r = random_number
  jr $ra          							# jump back to caller

rand:
# laod all constants
  lw $t1,const_a  							# load value of const_a into register
  lw $t2,const_b  							# load value of const_b into register
  lw $t3,const_m  							# load value of const_m into register
# calculate the random number $t1 = a, $t2 = b, $t3 = m
  lw $t4,r  								# load r, $t4 = r
  multu $t1,$t4 							# (a * r) in $t5
  mflo $t5
# convert to absolute value
# input and output in $t5 - absolute value
  sra $t1,$t5,31
  xor $t5,$t5,$t1
  sub $t5,$t5,$t1
# end absolute value, in $t1 -1 after operation
  add $t6,$t5,$t2 							# (a * r) + b in $t6
  div $t6,$t3     							# ((a * r) + b) / m lo = quotient, hi = reminder
  mfhi $v0        							#  ((a * r) + b) % m in $v0, since reminder in hi
  sw $v0,r      							# save the new r value in global section
  jr $ra          							# jump back to caller
	
frand:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal rand								# Jump to rand to get random number between 0 & 2^31 - 1
	lw $t0, const_max_value						# load content of max_value
	mtc1 $t0, $f4							# move max_value to coprocessor
	cvt.s.w $f4, $f4 						# convert max_vaue from int to single precision float
	addi $t0, $v0, 0						# $t0 = random number from rand function
	mtc1 $t0, $f5							# load random number in coprocessor
	cvt.s.w $f5, $f5 						# convert random number from integer to floating point
	div.s $f0, $f5, $f4					# $f0 = result = random number / max_random
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j $ra									# jump back to calling function
	
	

generate_list_item:							#TBD: In die MAIN packen?
#$f0 = random_value; $f12 = min_value; $f13 = max_value
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	mtc1 $a0, $f12							# move min_value to coprocessor
	cvt.s.w $f12, $f12 						# convert min_vaue from int to single precision float
	mtc1 $a1, $f13							# move max_value to coprocessor
	cvt.s.w $f13, $f13 						# convert max_vaue from int to single precision float
	
	jal frand 								# get rand number
	sub.s $f4, $f13, $f12					# $f4 = max_value - min_value
	mul.s $f4, $f0, $f4 					# $f4 = random_value * (max_value - min_value)
	add.s $f0, $f12, $f4 					# $f0 = min_value + random_value * (max_value - min_value)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j $ra									# jump back to calling function

generate_list:
# $a0 = n, $a1 = min, $a2 = max 
	addi $sp,$sp, -16
	sw $ra, 12($sp)							# save $ra on stack
	sw $s2, 8($sp)							# save $s2 on stack
	sw $s1, 4($sp)							# save $s1 on the stack				
	sw $s0, 0($sp)							# save $s0 on the stack
	move $s0, $a0							# save n in $s0
	move $s1, $a1							# save min_value in $s1
	move $s2, $a2							# save max_value in $s2
	j generate_list_loop
	
generate_list_loop:
	beq $s0, $zero, exit_generate_list_loop # if n reaches 0 exit
	addi $s0, $s0, -1  						#decrement loop invariant by 1
	move $a0, $s1							# set min_value for subroutine on $a0
	move $a1, $s2 							# set max_value for subroutine on $a1
	jal generate_list_item
	#TBD: Save on heap
	mov.s $f12, $f0   						# move $f0 to $f12 for syscall
	li $v0, 2 								# print_float for syscall
	syscall
	la $a0, line_break						# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	j generate_list_loop					# jump to lsit loop
	
exit_generate_list_loop:
	lw $ra, 12($sp)							# restore $ra from stack
	lw $s2, 8($sp)							# restore $s2 from stack
	lw $s1, 4($sp)							# restore $s1 from stack				
	lw $s0, 0($sp)							# restore $s0 from stack
	addi $sp, $sp, 16
	jr $ra

main:
	lw $s0, const_m 						# $s0 = 2^31 maximal number we support
	la $a0, n_input_message					# Load input message for n
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5       						# read n from input  
	syscall 
	move $a1, $v0							# $a1 = n read from input
	ble $a1, $zero, error_negative_amount	# if wanted amount of numbers is negative, show error
	
	la $a0, min_value_input_message			# Load input message for the min value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5      							# read min from input 
	syscall 
	move $a2, $v0							# $a2 = min read from input
	bge $a2, $s0, error_exceeded_range		# if min >= max_value
	
	la $a0, max_value_input_message			# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5       						# read max from input 
	syscall 
	move $a3, $v0							# $a3 = max read from input
	bge $a3, $s0, error_exceeded_range
	
	slt $t0, $a2, $a3						# If min < max then TRUE
	beq $t0, $zero, exit_sort				# else goto exit_sort
	beq $a2, $a3, error_min_max				# If min = max goto error_min_max
	move $a0, $a1							# move n after all syscalls in $a0 to meet mips convention
	move $s0, $a0							# save n for counting purposes in $s0
	jal seed 								# init r value
	
	move $a1, $a2							# move min_value to $a0
	move $a2, $a3							# move max_value to $a1
	jal generate_list	 					# generate list
	
	la $a0, succesfully_sorted_message		# Load successfull message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	
	li $v0, 10								# Load exit code to exit the program cleanly
	syscall									# perform the syscall
	
	
	
	
	
	