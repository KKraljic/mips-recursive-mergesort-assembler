.data
str1: .asciiz("")

.text


recursive_merge_sort:
#$a0 =  lo; $a1 = hi; $a2 = mid; $a3 = aux; a is written on the stack by calling procedure...
	slt $t0, $a0, $a1						#If lo < hi then TRUE
	beq $t0, $zero, exit_sort
	addi $sp, $sp, -12						#decrease stackpointer to store the mid value, sp and fp
	sw $ra, 8($sp)							#save ra on the stack
	sw $fp, 4($sp)							#save fp on the stack
	addi $fp, $sp, XXX						#set fp at the beginning of the frame TBD: Where is begin of this frame?
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
	


main:
	