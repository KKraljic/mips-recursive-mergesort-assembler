.data
#file strings
input_file: .asciiz "C:\\assembler\\mergesort_recursive_input.txt"
output_file: .asciiz "C:\\assembler\\mergesort_recursive_output.txt"

#menu strings
select_input: .asciiz "Please select the method of input you want to use. \n\t1: Use your mergesort_recursive_input.txt file \n\t0: Generate several random numbers using this program.\n"  

#informational strings
line_break: .asciiz "\n"
n_input_message: .asciiz "\nPlease enter here the amount of numbers that should be generated:"
min_value_input_message: .asciiz "\nPlease enter the min value of the wished data range:"
max_value_input_message: .asciiz "\nPlease enter the max value of the wished data range:"
succesfully_sorted_message: .asciiz "\nSeems that everything is OK... But never trust a running system. There MUST be a bug! :D"
print_unsorted_message: .asciiz "Your unsorted array is:\n"
print_sorted_message: .asciiz "\nYour sorted array is:\n"


#error messages
error_unknown_input: .asciiz "\nError: This is nit a valid parameter. Please try it again.\n"
error_invalid_input_message: .asciiz "\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n"
error_negative_amount_message: .asciiz "\nYou tried to get a negative amount. We're not magicians. Try it again."
error_exceeded_range_message: .asciiz "\nIt seems that you are not getting enough... Try it again. Smob."
error_invalid_char_message: .asciiz "\nYou did not enter a valid number. Hint:([0-9A-F]{8})(,[0-9A-F]{8})*\.\n"
error_file_not_found_message: .asciiz "\nThe file 'mergesort_recursive_input.txt' was not found in c:\assembler\ . Please check if the file is available.\n\n"

#constants
const_max_value: .word 2147483647			# max_value = 2^31 -1
const_a: .word 1103515245 					# init a, value for 32bit CPU
const_b: .word 12345 						# init b
const_m: .word 2147483648 					# equals 2^(31)
x: .space 4
buffer: .space 12500

.globl main
.text

#=====================Error Handling area
error_file_not_found:
	addi $t0, $zero, -1
	jal open_output_file					# fopen(output_file);
	beq $v0, $t0, create_output_file		# if(fileOutputDescriptor == -1){...}
	move $s6, $v0      						# $s6 = $v0 = fileOutputDescriptor

	la $a0, error_file_not_found_message	# Load input message for the error message,input file was not found
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nThe file 'mergesort_recursive_input.txt' was not found in c:\assembler\ . Please check if the file is available.\n\n");
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# move file descriptor to $a0
	la $a1, error_file_not_found_message	# source to write from
	li $a2, 114								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nThe file 'mergesort_recursive_input.txt' was not found in c:\assembler\ . Please check if the file is available.\n\n");
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# $a0 = $s6 = fileOutputDescriptor
	syscall            						# fclose(fileOutputDescriptor)
	
	j main									# start program again
	

error_invalid_char:
	la $a0, error_invalid_char_message		# Load input message for the error message, if user entered not a valid Hex number
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nYou did not enter a valid number. Hint:([0-9A-F]{8})(,[0-9A-F]{8})*\.\n")
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = $s6 = fileOutputDescriptor
	la $a1, error_invalid_char_message		# source to write from
	li $a2, 70								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nYou did not enter a valid number. Hint:([0-9A-F]{8})(,[0-9A-F]{8})*\.\n")
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# $a0 = $s6 = fileOutputDescriptor
	syscall            						# fclose(fileOutputDescriptor)
	
	j main									# start program again


error_min_max:
	la $a0, error_invalid_input_message		# Load input message for the error message, if min is >= max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n")
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = $s6 = fileOutputDescriptor
	la $a1, error_invalid_input_message		# source to write from
	li $a2, 102								# amount of bytes to be written
	syscall									# fprintf("\nError: Your min and max value are either in wrong order or they are the same. Please try it again.\n\n")
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# $a0 = $s6 = fileOutputDescriptor
	syscall            						# fclose(fileOutputDescriptor)
	
	j main									# start program again

error_negative_amount:
	la $a0, error_negative_amount_message	# Load input message for the error message, if n <= 0
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nYou tried to get a negative amount. We're not magicians. Try it again.")
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = $s6 = fileOutputDescriptor
	la $a1, error_negative_amount_message	# source to write from
	li $a2, 71								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nYou tried to get a negative amount. We're not magicians. Try it again.");
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# $a0 = $s6 = fileOutputDescriptor
	syscall            						# fclose(fileOutputDescriptor)
	
	j main									# start program again

error_exceeded_range:
	la $a0, error_exceeded_range_message	# Load input message for the error message, if {min_value; max_value} >= 2^31
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nIt seems that you are not getting enough... Try it again. Smob.")
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = $s6 = fileOutputDescriptor
	la $a1, error_exceeded_range_message	# source to write from
	li $a2, 64								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nIt seems that you are not getting enough... Try it again. Smob.")
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# $a0 = $s6 = fileOutputDescriptor
    syscall            						# fclose(fileOutputDescriptor)
	
	j main									# start program again

#=========================End Error Handling
#=========================Start of print logic

print_array:
#$a0 = a, $a1 = n, $a2 = file descriptor
	addi $sp,$sp, -20						# reserve space on stack
	sw $ra, 16($sp)							# save $ra on stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)							# save $s0 on stack
	
	move $s3, $a2							# $a2 = $a2 = file descriptor
	move $s2, $zero 						# $s2 = 0
	move $s1, $a1 							# $s1 = $a1 = n
	move $s0, $a0							# $s0 = $a0 = a
	j print_loop

print_loop:
	bge $s2, $s1, exit_print_loop			# if(temp >= n){exit loop}
	
	sll $t0, $s2, 2 						# offset = temp * 4
	add $t1, $s0, $t0						# address of entry = a + offset
	
	lwc1 $f12, 0($t1)						# save floating point number in $f12
	li $v0, 2 								# printf("%f\n", a[temp]);
	syscall
	
	li $v0, 15								# syscall to write to file
	move $a0, $s3							# $a0 = fileOutputDescriptor
	la $a1, 0($t1)							# source to write from
	li $a2, 4								# amount of bytes to be written
	syscall									# printf(fileOutputDescriptor, "%f\n", a[temp]);
	
	la $a0, line_break						# $ a0 = "\n"
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\n");

	li $v0, 15								# syscall to write to file
    move $a0, $s3							# $a0 = fileOutputDescriptor
    la $a1, line_break						# $a1 = "\n"
    li $a2, 1								# amount of bytes to be written
    syscall									# fprintf(fileOutputDescriptor, "\n", data[temp]);
	
	addi $s2, 1
	j print_loop

exit_print_loop:
	sw $ra, 12($sp)							# Restore $ra from stack
	sw $s2, 8($sp)							# Restore $s2 from stack
	sw $s1, 4($sp)							# Restore $s1 from stack
	sw $s0, 0($sp)							# Restore $s0 from stack
	addi $sp,$sp, 16
	
	jr $ra
#======================================End of print logic
#======================================Start of initilization of sort logic
fsort:
	addi $sp, $sp, -8						# Reserve space on stack
	sw $ra, 4($sp)							# Save jump back address on stack
	sw $s0, 0($sp)							# Save $s0 on memory

	move $t0, $a0							# $t0 = $a0 = a
	move $t1, $a1							# $t1 = $a1 = n

	sll $a0, $a1, 2							# $a0 = n * 4
	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# malloc( n * sizeof(float));
	move $fp, $v0 							# $fp = $v0 = aux

	move $s0, $v0							# $s0 = $v0 = aux
	move $a0, $t0 							# $a0 = $t0 = a
	move $a1, $zero 						# $a1 = 0
	addi $a2, $t1, -1						# $a2 = $t1 = n-1
	move $a3, $s0							# $a3 = $s0 = aux
	
	jal recursive_merge                     # recursive_merge(a, 0, n-1, aux);
	
	lw $ra, 4($sp)							# Restore jump back address from stack
	lw $s0, 0($sp)							# Restore $s0 from stack
	addi $sp, $sp, 8						# Free space from stack

	jr	$ra									# Jump back to calling function
#======================================End of initilization of sort logic
#=========================Start of split logic
recursive_merge:
	addi $sp, $sp, -24						#decrease stackpointer
	sw $ra, 20($sp)							#save ra on the stack
	sw $s4, 16($sp)
	sw $s3, 12($sp)							# save $s3 on stack
	sw $s2, 8($sp)							# save $s2 on stack
	sw $s1, 4($sp)							# save $s1 on stack
	sw $s0, 0($sp)							# save $s0 on stack

	move $s0, $a0							# $s0 = $a0 = a
	move $s1, $a1							# $s1 = $a1 = lo
	move $s2, $a2							# $s2 = $a2 = hi
	move $s3, $a3							# $s3 = $a3 = aux

	bge $s1, $s2, exit_split				# if(hi > lo){...}

	add $s4, $s1, $s2						# $s4 = lo + hi
	srl $s4, $s4, 1							# $s4 = mid = (lo + hi) / 2

	move $a0, $s0                           # $a0 = $s0 = a
	move $a1, $s1                           # $a1 = $s1 = lo
	move $a2, $s4							# $a2 = $s4 = (new) mid
	move $a3, $s3                           # $a3 = $s3 = aux
	jal recursive_merge                     # recursive_merge(a, lo, mid, aux);

	addi $t0, $s4, 1						# $t0 = mid = mid + 1
	
	move $a0, $s0							# $a0 = $s0 = a
	move $a1, $t0 							# $a1 = $t0  = mid + 1
	move $a2, $s2							# $a2 = $s2 = hi
	move $a3, $s3							# $a3 = $s3 = aux
	jal recursive_merge                     # recursive_merge(a, mid+1, hi, aux)

	move $a0, $s0							# $a0 = address of input array
	move $a1, $s1							# $a1 = $s1 = lo
	move $a2, $s4							# $a2 = $s4 = mid
	move $a3, $s2							# $a3 = $s2 = hi
	addi $sp, $sp, -4						# reserve place on stack
	sw $s3, 0($sp)							# write $s3 = aux on stack
	jal merge                               # merge(a, lo, mid, hi, aux);

	lw $ra, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 24						# free stack

	jr $ra

exit_split:
	lw $ra, 20($sp)							#Restore ra from the stack
	lw $s4, 16($sp)
	lw $s3, 12($sp)							# Restore $s3 from stack
	lw $s2, 8($sp)							# Restore $s2 from stack
	lw $s1, 4($sp)							# Restore $s1 from stack
	lw $s0, 0($sp)							# Restore $s0 from stack
	addi $sp, $sp, 24						# Free stack

	jr $ra
#=================================End of split logic

#=================================Start of merge logic

merge:
	lw $t0, 0($sp)							# $t0 = aux from calling procedure
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

	move $s4, $t0							# $s4 = $t0 = aux
	move $s3, $a3							# $s3 = $a3 = hi
	move $s2, $a2							# $s2 = $a2 = mid
	move $s1, $a1							# $s1 = $a1 = lo
	move $s0, $a0							# $s0 = $a0 = input array address a

	move $s7, $s1							# $s7 = i = lo
	addi $s5, $s2, 1						# $s5 = j = mid + 1
	move $s6, $s1 							# $s6 = k = lo
	j merge_first_loop

merge_first_loop:
	bgt $s6, $s3, merge_second_loop_initiation# if(k > hi){...}

	move $a0, $s4							# $a0 = $s4 = aux
	move $a1, $s0							# $a1 = $s0 = a
	move $a2, $s6							# $a2 = $s6 = k
	move $a3, $s6							# $a3 = $s6 = k

	jal assign_array_content                # aux[k] = a[k];

	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_first_loop						# go back to loop beginning


merge_second_loop_initiation:
	move $s6, $s1							# $s6 = k = lo
	j merge_second_loop

merge_second_loop:
	bgt $s6, $s3, exit_second_loop			# if(k > hi){...}
	bgt $s7, $s2, first_lvl_if				# if(i > mid){...}
	j first_lvl_else						# else{...}
	
first_lvl_if:
	move $a0, $s0							# $a0 = $s0 = a
	move $a1, $s4							# $a1 = $s4 = aux
	move $a2, $s6							# $a2 = $s6 = k
	move $a3, $s5							# $a3 = $s5 = j

	jal assign_array_content                # a[k] = aux[j] ;

	addi $s5, $s5, 1 						# $s5 = j = j++
	addi $s6, $s6, 1						# $s6 = k = k + 1
	j merge_second_loop						# go back to loop beginning

first_lvl_else:
	bgt $s5, $s3, second_lvl_if				# if(j > hi){...}
	j second_lvl_else

second_lvl_if:
	move $a0, $s0							# $a0 = $s0 = a
	move $a1, $s4							# $a1 = $s4 = aux
	move $a2, $s6							# $a2 = $s6 = k
	move $a3, $s7							# $a3 = $s7 = i

	jal assign_array_content                # a[k] = aux[i];
	
	addi $s7, $s7, 1 						# $s7 = i = i++
	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

second_lvl_else:
	sll $t0, $s5, 2 						# $t0 = j * 4
	sll $t1, $s7, 2							# $t1 = i * 4
	add $t0, $s4, $t0 						# $t0 = address of aux[j]
	add $t1, $s4, $t1						# $t1 = address of aux[i]

	lwc1 $f0, 0($t0)						# $f0 = content of aux[j]
	lwc1 $f1, 0($t1) 						# $f1 = content of aux[i]

	c.lt.s $f0, $f1
	bc1t third_lvl_if						# if(aux[j] < aux[i]){...}
	j third_lvl_else

third_lvl_if:
	move $a0, $s0							# $a0 = $s0 = a
	move $a1, $s4							# $a1 = $s4 = aux
	move $a2, $s6							# $a2 = $s6 = k
	move $a3, $s5							# $a3 = $s5 = j

	jal assign_array_content                # a[k] = aux[j];
	
	addi $s5, $s5, 1 						# $s5 = j = j++
	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

third_lvl_else:
	move $a0, $s0							# $a0 = $s0 = a
	move $a1, $s4							# $a1 = $s4 = aux
	move $a2, $s6							# $a2 = $s6 = k
	move $a3, $s7							# $a3 = $s7 = i

	jal assign_array_content                # a[k] = aux[i];
	
	addi $s7, $s7, 1 						# $s7 = i = i++
	addi $s6, $s6, 1						# $s6 = k + 1
	j merge_second_loop						# go back to loop beginning

exit_second_loop:

	lw $ra, 32($sp)							# restore jump back address on stack
	lw $s7, 28($sp)
	lw $s6, 24($sp)
	lw $s5, 20($sp)
	lw $s4, 16($sp)							# restore $s4 from stack
	lw $s3, 12($sp)							# restore $s3 from stack
	lw $s2, 8($sp)							# restore $s2 from stack
	lw $s1, 4($sp)							# restore $s1 from stack
	lw $s0, 0($sp)							# restore $s0 from stack

	addi $sp, $sp, 40						# free stack + delete aux[k] from stack stored by calling procedure

	jr $ra



assign_array_content:
# $a0 = a ; $a1 = aux; $a2 = k ; $a3 = j;
	addi $sp, $sp, -4						# reserve memory on stack
	sw $ra, 0($sp)							# save $ra on stack

	sll $t0, $a2, 2 						# $t0 = k * 4
	sll $t1, $a3, 2							# $t1 = j * 4
	addu $t2, $a0, $t0 						# $t2 = address of a[k]
	addu $t3, $a1, $t1						# $t3 = address of aux[j]
	lw $t4, 0($t3)							# $t4 = content of aux[j]
	sw $t4, 0($t2)							# a[k] = aux[j]
	
	lw $ra, 0($sp)							# load jump back address from stack
	addi $sp, $sp, 4						# free memory from stack
	jr $ra

#=================================End of merge logic

#=================================Start of random number generator logic
seed:
# $a0 = n
	mfc0 $t1, $9							# $t1 = execution_time
	multu $sp, $t1   						# random_addr * execution_time
	mflo $t0        						# $t0 = random_number = random_addr * execution_time
	divu $t0, $a0                           # random_number / n
	mflo $t0                                # $t0 = random_number

	la $t1, x        						# load address of global value x
	sw $t0, 0($t1)  						# x = $t0
	jr $ra          						# jump back to caller

rand:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)	
	
# load all constants
	lw $s0, x								# $s0 = x
	li $s1, 69069 							# $s1 = 69069
	lw $s2, const_m                         # $s2 = const_m
	li $s3, 12345                           # $s3 = 12345
	
	li $t0, 181218000						# $t0 = y
	li $t1, 260644315						# $t1 = z
	li $t2, 38271601						# $t2 = c
	li $t3, 698769069						# $t3 = 698769069
	
# Calculate linear congruential generator
	multu $s0, $s1 							# (69069 * x)
	mflo $t1                                # $t1 = (69069 * x)
	addu $s0, $t1, $s3 						# $s0 = x = (69069 * x) + 12345

#Xorshift
	sll $t4, $t0, 13                        # $t4 = y << 13
	xor $t0, $t0, $t4                       # $t4 = $t4 XOR y <<13
	sll $t4, $t0, 17                        # $t4 = $t4 >> 17
	xor $t0, $t0, $t4                       # $t4 = $t4 XOR $t4 >> 17
	sll $t4, $t0, 5                         # $t4 = $t4 << 5
	xor $t0, $t0, $t4                       # $t4 = $t4 XOR $t4 << 5
	
#Multiply-with-carry
	multu $t3, $t1							# 698769069 * z
	mfhi $t5								# $t5 = c = t >> 32
	addu $t2, $t5, $t2						# $t2 = z = 698769069 * z + c
	
	addu $s0, $s0, $t0 						# $s0 = x + y
	addu $s0, $s0, $t2                      # $s0 = x + y + z
	divu $s0, $s2     						# x % const_m
	mfhi $v0        						# $v0 = x = x % const_m
	sw $v0, x   	                        # return x
	
	lw $ra, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 24	
	
	jr $ra          						# jump back to caller

frand:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal rand
	lw $t0, const_max_value					# $t0 = const_max_value
	mtc1 $t0, $f4							# $f4 = $t0 = const_max_value
	cvt.s.w $f4, $f4 						# convert max_value from int to single precision float
	move $t0, $v0						    # $t0 = $v0 = current_rand
	mtc1 $t0, $f5							# load current_rand in coprocessor
	cvt.s.w $f5, $f5 						# convert current_rand from integer to floating point
	div.s $f0, $f5, $f4						# $f0 = current_rand / const_max_value

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j $ra									# jump back to calling function



generate_list_item:							
#$f0 = random_value; $f12 = min_value; $f13 = max_value
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	mtc1 $a0, $f12							# $f12 = min_value
	cvt.s.w $f12, $f12 						# convert min_value from int to single precision float
	mtc1 $a1, $f13							# $f13 = max_value
	cvt.s.w $f13, $f13 						# convert max_value from int to single precision float

	jal frand 								# get rand number
	sub.s $f4, $f13, $f12					# $f4 = max_value - min_value
	mul.s $f4, $f0, $f4 					# $f4 = random_value * (max_value - min_value)
	add.s $f0, $f12, $f4 					# $f0 = min_value + (random_value * (max_value - min_value))
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j $ra									# jump back to calling function

generate_list:
# $a0 = n, $a1 = min, $a2 = max
	addi $sp,$sp, -20
	sw $ra, 16($sp)							# save $ra on stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	move $s0, $a0							# $s0 = n
	move $s1, $a1							# $s1 = min_value
	move $s2, $a2							# $s2 = max_value
	j generate_list_loop

generate_list_loop:
	beq $s0, $zero, exit_generate_list_loop # if n reaches 0 exit
	move $a0, $s1							# $a0 = $s1 = min_value
	move $a1, $s2 							# $a1 = $s2 = max_value
	
	jal generate_list_item

	swc1 $f0, 0($fp)						# save item at current position of heap	
	
	addi $fp, $fp, 4
    addi $s0, $s0, -1  						# $s0 = n = n -1
	j generate_list_loop					# jump to list loop

exit_generate_list_loop:
	lw $ra, 16($sp)							# restore $ra from stack
	lw $s3, 12($sp)
	lw $s2, 8($sp)							# restore $s2 from stack
	lw $s1, 4($sp)							# restore $s1 from stack
	lw $s0, 0($sp)							# restore $s0 from stack
	addi $sp, $sp, 16
	jr $ra
#=================================End of random number generator logic
#=================================Start of create & open output file logic
open_output_file:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li   $v0, 13       						# system call for open file
	la   $a0, output_file					# output file name
	li   $a1, 1        						# Open for writing (flags are 0: read, 1: write)
	li   $a2, 0        						# mode is ignored
	syscall            						# $v0 = fopen(output_file, "w" );
	
	sw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

create_output_file:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li   $v0, 13       						# system call for open file
	la   $a0, output_file					# output file name
	li $a1, 0x102   						# create file       
	li $a2, 0x1FF  							# set permissions
	syscall            						# $ v0 = fopen(output_file, "w+");
	
	sw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#====================================End of create & open output file logic
	
#====================================Start of convert from hex to binary
check_and_convert_to_binary:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)	
	
	move $s0, $a0							# $s0 = current digit
	
	li $t0, 48								# $t0 = 48 = Ascii 0
	li $t1, 57								# $t1 = 57 = Ascii 9
	li $t2, 65								# $t2 = 65 = Ascii A
	li $t3, 70								# $t3 = 70 = Ascii F
	li $t4, 1								# $t4 = 1 = Ascii Start of Heading
	
	beq $s0, $t4, convert_input_loop
	bltu $s0, $t0, error_invalid_char 		# if $s0 < 48 then stop (numbers start in Ascii at 48!)
	bgtu $s0, $t1, check_letters			# if $s0 > 57 then check letters (9, the biggest number, is Ascii 57)
	
	addiu $v0, $s0, -48						# $v0 = Ascii value digit - 48 
	j finish_convert_to_binary
	
check_letters:
	bltu $s0, $t2, error_invalid_char		# if $s0 < 65 then stop (digit not number nor Hex letter)
	bgtu $s0, $t3, error_invalid_char		# if $s0 > 70 then stop (digit not number nor Hex letter)
	addiu $v0, $s0, -55						# $v0 = Ascii value digit - 55
	j finish_convert_to_binary

finish_convert_to_binary:
	lw $ra, 4($sp)
	lw $s0, 0($sp)	
	addi $sp, $sp, 8
	jr $ra
#====================================End of convert from hex to binary

#====================================Start of read from file
read_and_convert_from_input:
	move $t9, $zero
	move $t9, $a0							# $t9 = file descriptor... We'll burn in hell for this.
	addi $sp, $sp, -40
	sw $ra, 36($sp)
	sw $s7, 32($sp)
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $t9, 0($sp)
	
	la $s1, buffer
	addi $a0, $zero, 0						# $a0 = 0
	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# takes size from $a0 = 0 and allocates the memory on heap
	move $s4, $v0							# $s4 = start address of input array
	addi $s6, $zero, 46						# $s6 = value of Ascii "."- our termination string
	addi $s7, $zero, 44						# $s7 = value of Ascii ","- our seperator
	move $s3, $zero							# $s3 = 0; value of hex number
	
#Read gs symbol --> control symbol of OS
	li   $v0, 14       						# system call for read from file
	move $a0, $t9      						# $a0 = file descriptor 
	move $a1, $s1   						# read to buffer
	li   $a2, 12500	   						# read 12500 characters from input file
	syscall            						# read from file
	
	j convert_input_loop
	
read_next_number:
	addi $a0, $zero, 4						# $a0 = 4
	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# takes size from $a0 = 4 and allocates the memory on heap	
	sw $s3, 0($v0)							# Save current number on heap
	move $s0, $zero 						# $s3 = 0
	
	addi $s5, $s5, 1						# $s5 = n = n + 1
	
	j convert_input_loop
	
convert_input_loop:
	lbu $s2, 0($s1)							# current symbol = symbol in buffer
	addiu $s1, $s1, 1						# increase address of buffer
	
	beq $s2, $s6, convert_input_loop_exit 	# if $s2 = . (termination symbol) goto read_from_input_loop_exit
	beq $s2, $s7, read_next_number			# if $s2 = , (seperator) goto read_next_number
	sll $s3, $s3, 4							# shift $s3 by 16^1 digits (1 hex digit)
	move $a0, $s2
	jal check_and_convert_to_binary		
	lw $t9, 0($sp)							# restore file descriptor
	move $s2, $v0 							# $s2 = binary value of current symbol
	addu $s3, $s3, $s2						# $s3 = current value of overall number	
	
	j convert_input_loop

convert_input_loop_exit:
	addi $a0, $zero, 4						# $a0 = 4
	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# takes size from $a0 = 4 and allocates the memory on heap	
	sw $s3, 0($v0)							# Save current number on heap

	addi $s5, $s5, 1						# $s5 = n = n + 1
	move $v0, $s4							# $v0 = start address of array on heap
	move $v1, $s5							# $v1 = n 
	
	lw $ra, 36($sp)
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $t9, 0($sp)
	addi $sp, $sp, 40
	
	jr $ra
#====================================End of read from file
#====================================Start of 'main' of Auto_generate_number 
auto_generate_numbers:
	addi $t0, $zero, -1
	jal open_output_file					# open the file to write to
	beq $v0, $t0, create_output_file		# fopen(output_file, ...);
	move $s6, $v0      						# $s6 = $v0 = fileOutputDescriptor;
	
	lw $s0, const_m 						# $s0 = const_m = 2^31 maximal number we support
	la $a0, n_input_message					# Load input message for n
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string

	li $v0, 5       						# read n from input
	syscall                                 # scanf("%i", &n);
	move $s2, $v0							# $s2 = $v0 = n read from input

	ble $a1, $zero, error_negative_amount	# if(n < 0){...}

	la $a0, min_value_input_message			# Load input message for the min_value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nPlease enter the min value of the wished data range\n");

	li $v0, 5      							# read min_value from input
	syscall                                 # scanf("%i", &min_value);
	move $a2, $v0							# $a2 = min_value

	la $a0, max_value_input_message			# Load input message for the max_value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nPlease enter the max value of the wished data range\n");
	li $v0, 5       						# read max_value from input
	syscall                                 # scanf("%i", &max_value);
	move $a3, $v0							# $a3 = max_value

	bge $a3, $s0, error_exceeded_range      # if(max_value >= const_m){...}

	bge $a2, $s0, error_exceeded_range		# if(min_value >= const_m){...}
    bge $a2, $a3, error_min_max 			# OR if(min_value >= max_value ){...}

    move $a1, $s2							# $a1 = $s2 =  n
	sll $a0, $a1, 2							# $a0 = size of array = n * 4

	li $v0, 9								# Syscall to allocate memory on heap
	syscall 								# malloc(n * sizeof(...));
	move $s1, $v0							# $s1 = a = malloc(...);
	move $fp, $s1 							# $fp = $s1 = a

	move $a0, $s2							# $a0 = $a1 = n
	jal seed 								# seed(n);
	
	move $a1, $a2							# $a1 = min_value
	move $a2, $a3							# $a2 = max_value
	move $a3, $s6							# $a3 = a
	jal generate_list	 					# generate list(n, min_value, max_value, a);

	la $a0, print_unsorted_message			# Load input message for print_unsorted_message
	li $v0, 4								# Load I/O code to print string to console
	syscall	                                # printf("\nThe unsorted array is:\n");
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# move file descriptor to $a0
	la $a1, print_unsorted_message			# source to write from
	li $a2, 25								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nThe unsorted array is:\n");
	
	move $a0, $s1							# $a0 = $s1 = a
	move $a1, $s2							# $a1 = $s2 = n
	move $a2, $s6							# $a2 = $s6 = fileOutputDescriptor
	jal print_array					        # print_array(a, n, fileOutputDescriptor);
	
	move $a0, $s0 							# $a0 = $s0 = a
	move $a1, $s1							# $a1 = $s1 = n
	jal fsort								# fsort(a, n);
	
	
	
	la $a0, print_sorted_message			# Load input message for print_initiaton_message
	li $v0, 4								# Load I/O code to print string to console
	syscall	                                # printf("\nThe sorted array is:\n");
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# move file descriptor to $a0
	la $a1, print_sorted_message			# source to write from
	li $a2, 23								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nThe sorted array is:\n");

	move $a0, $s0							# $a0 = $s0 = a
	move $a1, $s1							# $a1 = $s1 = n
	move $a2, $s6                           # $a2 = $s6 = fileOutputDescriptor
	jal print_array                         # print_array(a, n, fileOutputDescriptor);

	la $a0, succesfully_sorted_message		# Load successfull message for the max value
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nSeems that everything is OK... But never trust a running system. There MUST be a bug! :D");
	
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# move file descriptor to $a0
	la $a1, succesfully_sorted_message		# source to write from
	li $a2, 89								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nSeems that everything is OK... But never trust a running system. There MUST be a bug! :D");
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# file descriptor to close
	syscall            						# fclose(fileOutputDescriptor);

	li $v0, 10								# Load exit code to exit the program cleanly
	syscall									# exit programm
#====================================End of 'main' of Auto_generate_number 
#====================================Start of 'main' of Read_from_file 
read_from_file:	
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	li $t0, -1 								# $t0 = -1
	
	li   $v0, 13       						# system call to open file
	la   $a0, input_file					# file name & path of targeted file
	li   $a1, 0        						# Open for reading (flags are 0: read, 1: write)
	li   $a2, 0        						# mode is ignored
	syscall            						# fopen(input_file, flag);
	move $s6, $v0							# $s6 = $v0 = input_file = fopen(...);
	
	beq $s6, $t0, error_file_not_found		# if($s6 = input_file = -1){goto print error messages...};
	
	move $a0, $s6							# $a0 = $s6 = input_file
	
	jal read_and_convert_from_input	
	
	move $s0, $v0							#$s0 = a;start address of input array
	move $s1, $v1 							#$s1 = n; amount of items
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# file descriptor to close input_file
	syscall            						# fclose(input_file)
	
	addi $t0, $zero, -1
	jal open_output_file					# open target file
	beq $v0, $t0, create_output_file		# if( fileOutputDescriptor == -1){create the file}
	move $s6, $v0      						# $s6 = $v0 = fileOutputDescriptor
	
	la $a0, print_unsorted_message			# Load input message for print_unsorted_message
	li $v0, 4								# Load I/O code to print string to console
	syscall	                                # printf("\nThe unsorted array is:\n");
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = fileOutputDescriptor
	la $a1, print_unsorted_message			# source to write from
	li $a2, 25								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nThe unsorted array is:\n")
	
	move $a0, $s0							# $a0 = a
	move $a1, $s1							# $a1 = n
	move $a2, $s6							# $a2 = fileOutputDescriptor
	jal print_array                         # print_array(a, n, fileOutputDescriptor);
	
	move $a0, $s0							# $a0 = a
	move $a1, $s1							# $a1 = n
	jal fsort                               # fsort(a, n);
	
	la $a0, print_sorted_message			# Load input message for print_sorted_message
	li $v0, 4								# Load I/O code to print string to console
	syscall	                                # printf("\nThe sorted array is:\n");
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = $s6 = fileOutputDescriptor
	la $a1, print_sorted_message			# source to write from
	li $a2, 25								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nThe sorted array is:\n");
	
	move $a0, $s0							# $a0 = a
	move $a1, $s1							# $a1 = n
	move $a2, $s6							# $a2 = $s6 = fileOutputDescriptor
	jal print_array
	
	la $a0, succesfully_sorted_message		# Load input message for succesfully_sorted_message
	li $v0, 4								# Load I/O code to print string to console
	syscall									# printf("\nSeems that everything is OK... But never trust a running system. There MUST be a bug! :D");
	
	
	li $v0, 15								# syscall to write to file
	move $a0, $s6							# $a0 = $s6 = fileOutputDescriptor
	la $a1, succesfully_sorted_message		# source to write from
	li $a2, 89								# amount of bytes to be written
	syscall									# fprintf(fileOutputDescriptor, "\nSeems that everything is OK... But never trust a running system. There MUST be a bug! :D");
	
	li   $v0, 16       						# system call for close file
	move $a0, $s6      						# file descriptor to close
	syscall            						# fclose(fileOutputDescriptor);

	li $v0, 10								# Load exit code to exit the program cleanly
	syscall									# Close program
#====================================Start of 'main' of Read_from_file 	

main:
	
	addi $t0, $zero, 1
	la $a0, select_input					# Load input message for wished input type
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	li $v0, 5      							# input_type = input from console
	syscall
	move $a0, $v0							# $a0 = input_type
	beq $a0, $zero, auto_generate_numbers	# if(input_type = 1){goto auto_generate_numbers}
	beq $a0, $t0, read_from_file			# else if(input_type = 0){goto read_from_file}
	addi $t0, $zero, 1
	la $a0, error_unknown_input				# else{goto error_unknown_input}
	li $v0, 4								# Load I/O code to print string to console
	syscall									# print string
	j main
