.data

#informational strings
line_break: .asciiz "\n"
n_input_message: .asciiz "\nPlease enter here the amount of numbers that should be generated:"
min_value_input_message: .asciiz "\nPlease enter the min value of the wished data range:"
max_value_input_message: .asciiz "\nPlease enter the max value of the wished data range:"
succesfully_sorted_message: .asciiz "\n Seems that everything is OK... But never trust a running system. There MUST be a bug! :D"
print_initiaton_message: .asciiz "\n Your sorted array is:\n"

#debug error messages
error_message_one: .asciiz " Your at position 1\n\n"
error_message_two: .asciiz "Your at position 2\n\n"
error_message_three: .asciiz "Your at position 3\n\n"
error_message_four: .asciiz " Your at position 4\n\n"
error_message_five: .asciiz " Your at position 5\n\n"
error_message_six: .asciiz " Your at position 6\n\n"
error_message_seven: .asciiz " Your at position 7\n\n"

#error messages
error_message_message: .asciiz "\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n"
error_negative_amount_message: .asciiz "\n You tried to get a negative amount. We're not magicians. Try it again."
error_exceeded_range_message: .asciiz "\n It seems that you are not getting enough... Try it again. Smob."

#constants
const_max_value: .word 2147483647			# max_value = 2^31 -1
const_a: .word 1103515245 					# init a, value for 32bit CPU
const_b: .word 12345 						# init b
const_m: .word 2147483648 					# equals 2^(31)
r: .space 4

.globl main
.text

recursive_merge:
#$a0 = a (address to input array on heap); $a1 = lo; $a2 = hi; $a3 = aux
	addi $sp, $sp, -24						#decrease stackpointer to store the mid value, sp and fp
	sw $ra, 20($sp)							#save ra on the stack
	sw $s4, 16($sp)
	sw $s3, 12($sp)							# save $s3 on stack
	sw $s2, 8($sp)							# save $s2 on stack
	sw $s1, 4($sp)							#save $s1 on stack
	sw $s0, 0($sp)							#save $s0 on stack

	move $s0, $a0							# $s0 = a
	move $s1, $a1							# $s1 = lo
	move $s2, $a2							# $s2 = hi
	move $s3, $a3							# $s3 = aux

	bge $s1, $s2, exit_split				# If lo >= hi then stop splitting
#Calculation of mid
	add $s4, $s1, $s2						# $s4 = lo + hi
	srl $s4, $s4, 1							# $s4 = mid = (lo + hi) / 2
	#move $s1, $a2							# save hi in $s1 for recursive calls later
	move $a0, $s0
	move $a1, $s1
	move $a2, $s4							# $a2 = new mid
	move $a3, $s3
	jal recursive_merge

	addi $t0, $s4, 1						# $t0 = mid = mid + 1
	
	move $a0, $s0								# restore array a
	move $a1, $t0 								# $a1 = mid + 1
	move $a2, $s2								# $a2 = hi
	move $a3, $s3								#restore array aux 
	jal recursive_merge

	move $a0, $s0							# $a0 = address of input array
	move $a1, $s1							# $a1 = lo


	move $a2, $s4							# $a2 = mid
	move $a3, $s2							# $a3 = hi
	addi $sp, $sp, -4						# reserve place on stack
	sw $s3, 0($sp)							# write $s3 = aux on stack
	jal merge

	lw $ra, 20($sp)							# Load ra from stack
	lw $s4, 16($sp)
	lw $s3, 12($sp)							# Load $s3 on stack
	lw $s2, 8($sp)							# Load $s2 on stack
	lw $s1, 4($sp)							# Load $s1 on stack
	lw $s0, 0($sp)							# Load $s0 on stack
	addi $sp, $sp, 24						#increase stackpointer to free the mid value, sp and fp

	jr $ra

exit_split:
	lw $ra, 20($sp)							#Restore ra from the stack
	lw $s4, 16($sp)
	lw $s3, 12($sp)							# Restore $s3 from stack
	lw $s2, 8($sp)							# Restore $s2 from stack
	lw $s1, 4($sp)							# Restore $s1 from stack
	lw $s0, 0($sp)							# Restore $s0 from stack
	addi $sp, $sp, 24						# Free memory on stack

	jr $ra

merge:
	lw $t0, 0($sp)							# get output array addres aux from stack
	addi $sp, $sp, -36						# make space on stack
	sw $ra, 32($sp)							# save jump back address on stack
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)							# save $s4 on stack
	sw $s3, 12($sp)							# save $s3 on stack
	sw $s2, 8($sp)							# save $s2 on stack
	sw $s1, 4($sp)							# save $s1 on stack
	sw $s0, 0($sp)							# save $s0 on stack

	move $s4, $t0							# $s4 = aux
	move $s3, $a3							# $s3 = hi
	move $s2, $a2							# $s2 = mid
	move $s1, $a1							# $s1 = lo
	move $s0, $a0							# $s0 = input array address a

	move $s7, $s1							# $s7 = i = lo
	addi $s5, $s2, 1						# $s5 = j = mid + 1
	move $s6, $s1 							# $s6 = k = lo
	j merge_first_loop

merge_first_loop:
	bgt $s6, $s3, merge_second_loop_initiation# if k > hi goto merge_second_loop

	move $a0, $s4							# $a0 = aux
	move $a1, $s0							# $a1 = a
	move $a2, $s6							# $a2 = k
	move $a3, $s6							# $a3 = k

	jal swap_array_content
	la $a0, error_message_one				# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string

	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_first_loop						# go back to loop beginning


merge_second_loop_initiation:
	move $s6, $s1							# $s6 = k = lo
	j merge_second_loop

merge_second_loop:
	bgt $s6, $s3, exit_second_loop			# if k > hi goto exit_second_loop
	bgt $s7, $s2, first_lvl_if				# if i > mid goto if
	j first_lvl_else						# else
	
first_lvl_if:
	move $a0, $s0							# $a0 = a
	move $a1, $s4							# $a1 = aux
	move $a2, $s6							# $a2 = k
	move $a3, $s5							# $a3 = j

	jal swap_array_content
	la $a0, error_message_two				# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string

	addi $s5, $s5, 1 						# $s5 = j = j++

	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

first_lvl_else:
	bgt $s5, $s3, second_lvl_if				# if j > hi goto if
	j second_lvl_else

second_lvl_if:
	move $a0, $s0							# $a0 = a
	move $a1, $s4							# $a1 = aux
	move $a2, $s6							# $a2 = k
	move $a3, $s7							# $a3 = i

	jal swap_array_content
	la $a0, error_message_three				# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	addi $s7, $s7, 1 						# $s7 = i = i++

	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

second_lvl_else:
	sll $t0, $s6, 2 						# $t0 = j * 4
	sll $t1, $a3, 2							# $t1 = i * 4
	add $t0, $a1, $t0 						# $t0 = address of aux[j]
	add $t1, $a1, $t1						# $t1 = address of aux[i]

	lwc1 $f0, 0($t0)						# $f0 = content of aux[j]
	lwc1 $f1, 0($t1) 						# $f1 = content of aux[i]

	c.lt.s $f1, $f0
	bc1t third_lvl_if						# if aux[j] < aux[i] goto third_lvl_else
	j third_lvl_else

third_lvl_if:
	move $a0, $s0							# $a0 = a
	move $a1, $s4							# $a1 = aux
	move $a2, $s6							# $a2 = k
	move $a3, $s5							# $a3 = j

	jal swap_array_content
	la $a0, error_message_four				# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	addi $s5, $s5, 1 						# $s5 = j = j++

	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

third_lvl_else:
	move $a0, $s0							# $a0 = a
	move $a1, $s4							# $a1 = aux
	move $a2, $s6							# $a2 = k
	move $a3, $s7							# $a3 = i

	jal swap_array_content
	la $a0, error_message_five				# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	addi $s7, $s7, 1 						# $s7 = i = i++

	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

exit_second_loop:

	lw $ra, 32($sp)							# restore jump back address on stack
	lw $s7, 28($sp)
	lw $s6, 24($sp)
	lw $s5, 20($sp)
	lw $s4, 16($sp)							# restore $s4 on stack
	lw $s3, 12($sp)							# restore $s3 on stack
	lw $s2, 8($sp)							# restore $s2 on stack
	lw $s1, 4($sp)							# restore $s1 on stack
	lw $s0, 0($sp)							# restore $s0 on stack

	addi $sp, $sp, 40						# make space on stack + delete aux[k] from stack

	jr $ra



swap_array_content:
# $a0 = a ; $a1 = aux; $a2 = k ; $a3 = j;
	addi $sp, $sp, -4						# reserve memory on stack
	sw $ra, 0($sp)							# save $ra on stack

	sll $t0, $a2, 2 						# $t0 = k * 4
	sll $t1, $a3, 2							# $t1 = j * 4
	addu $t2, $a0, $t0 						# $t2 = address of a[k]
	addu $t3, $a1, $t1						# $t3 = address of aux[j]
	lw $t4, 0($t3)							# $t4 = content of aux[j]
	sw $t4, 0($t2)							# a[k] = aux[j]
	#Debug...
	lwc1 $f12, 0($t2)						# save floating point number in $f12

	li $v0, 2 								# print_float for syscall
	syscall
	la $a0, line_break						# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string

	lw $ra, 0($sp)							# load jump back address from stack
	addi $sp, $sp, 4						# free memory from stack
	jr $ra



fsort:
	addi $sp, $sp, -8						# Reserve space on stack
	sw $ra, 4($sp)							# Save jump back address on stack
	sw $s0, 0($sp)							# Save $s0 on memory
	move $t0, $a0							# Move start address of input array on heap to $t0
	move $t1, $a1							# Move n to $t1
	sll $a0, $a1, 2							# $a0 = size of array = n * 4
	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# takes size from $a0 = n * 4 and allocates the memory on heap
	move $fp, $v0 							# Set $fp to new start address of output array
	#Prepare arguments for subprocedure
	move $s0, $v0							# Save start address of target array in $s0
	move $a0, $t0 							# $a0 = start address of input array on heap
	move $a1, $zero 						# $a1 = 0
	addi $a2, $t1, -1						# $a2 = n = n-1
	move $a3, $s0							# $a3 = start address of target heap

	jal recursive_merge

	sub $t2, $s0, $fp						# calculate negative difference between heap end and start of aux
	add $fp, $fp, $t2						# reset fp to correct stack address
	move $a0, $t2							# pass the bytes to free the heap
	li $v0, 9								# Syscall to free memory on heap
	syscall 								# free heap by $fp - aux

	lw $ra, 4($sp)							# Restore jump back address from stack
	lw $s0, 0($sp)							# Restore $s0 from stack
	addi $sp, $sp, 8						# Free space from stack

	jr	$ra									# Jump back to calling function






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
	multu $sp, $a0   						# random_addr * n
	mflo $t0        						# random_number = random_addr * n
# input and output in $t0 - absolute value
	sra $t1, $t0, 31
	xor $t0, $t0, $t1
	sub $t0, $t0, $t1
# end absolute value, in $t1 -1 after operation
	la $t1, r        						# laod address of global value r
	sw $t0, 0($t1)  						# r = random_number
	jr $ra          						# jump back to caller

rand:
# laod all constants
	lw $t1, const_a  						# load value of const_a into register
	lw $t2, const_b  						# load value of const_b into register
	lw $t3, const_m  						# load value of const_m into register
# calculate the random number $t1 = a, $t2 = b, $t3 = m
	lw $t4, r  								# load r, $t4 = r
	multu $t1, $t4 							# (a * r) in $t5
	mflo $t5
# convert to absolute value
# input and output in $t5 - absolute value
	sra $t1, $t5,31
	xor $t5, $t5, $t1
	sub $t5, $t5, $t1
# end absolute value, in $t1 -1 after operation
	addu $t6, $t5, $t2 						# (a * r) + b in $t6
	div $t6, $t3     						# ((a * r) + b) / m lo = quotient, hi = reminder
	mfhi $v0        						#  ((a * r) + b) % m in $v0, since reminder in hi
	sw $v0, r      							# save the new r value in global section
	jr $ra          						# jump back to caller

frand:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal rand								# Jump to rand to get random number between 0 & 2^31 - 1
	lw $t0, const_max_value					# load content of max_value
	mtc1 $t0, $f4							# move max_value to coprocessor
	cvt.s.w $f4, $f4 						# convert max_vaue from int to single precision float
	addi $t0, $v0, 0						# $t0 = random number from rand function
	mtc1 $t0, $f5							# load random number in coprocessor
	cvt.s.w $f5, $f5 						# convert random number from integer to floating point
	div.s $f0, $f5, $f4						# $f0 = result = random number / max_random
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
	
	mov.s $f12, $f0   						# move $f0 to $f12 for syscall
	swc1 $f0, 0($fp)						# save item at current position of heap
	addi $fp, $fp, 4
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
	
print_sorted_array:
#$a0 = a, $a1 = n
	addi $sp,$sp, -16						# reserve space on stack
	sw $ra, 12($sp)							# save $ra on stack
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)							# save $s0 on stack
	
	move $s2, $zero 						# $s2 = 0
	move $s1, $a1 							# $s1 = n
	move $s0, $a0							# $s0 = a
	j print_loop

print_loop:
	bge $s2, $s1, exit_print_loop			# if temp. counter variable >= n goto exit
	
	sll $t0, $s2, 2 						# offset = temp * 4
	add $t1, $s0, $t0						# address of entry = a + offset
	
	lwc1 $f12, 0($t1)						# save floating point number in $f12

	li $v0, 2 								# print_float for syscall
	syscall
	la $a0, line_break						# Load input message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	
	addi $s2, 1
	j print_loop

exit_print_loop:
	sw $ra, 12($sp)							# Restore $ra from stack
	sw $s2, 8($sp)							# Restore $s2 from stack
	sw $s1, 4($sp)							# Restore $s1 from stack
	sw $s0, 0($sp)							# Restore $s0 from stack
	addi $sp,$sp, 16
	
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
	move $s2, $a1							# save n in $s2

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
	beq $t0, $zero, error_min_max			# else goto error_min_max
	beq $a2, $a3, error_min_max				# If min = max goto error_min_max

	sll $a0, $a1, 2							# $a0 = size of array = n * 4
	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# takes size from $a0 = n * 4 and allocates the memory on heap
	move $s1, $v0							# Move start address of heap in $s1
	move $fp, $s1 							# Set frame pointer to start address of heap

	move $a0, $a1							# move n after all syscalls in $a0 to meet mips
	jal seed 								# init r value

	move $a1, $a2							# move min_value to $a0
	move $a2, $a3							# move max_value to $a1
	move $a3, $s1							# Move first addres of heap in $a3
	jal generate_list	 					# generate list

	move $a0, $s1 							# $a0 = start address of heap
	move $a1, $s2							# Restore n from $s2
	jal fsort								# Call fsort
	
	
	
	la $a0, print_initiaton_message			# Load input message for print_initiaton_message
	li $v0, 4								# Load I/O code to print string to console
	syscall	

	move $a0, $s1							# $a0 = a
	move $a1, $s2							# $a1 = n
	jal print_sorted_array

	la $a0, succesfully_sorted_message		# Load successfull message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string

	li $v0, 10								# Load exit code to exit the program cleanly
	syscall									# perform the syscall
