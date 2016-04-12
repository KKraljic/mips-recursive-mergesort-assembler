.data
r: .space 4
const_a: .word 1103515245 # init a, value for 32bit CPU
const_b: .word 12345 # init b
const_m: .word 2147483648 # equals 2^(31)
.globl main
.text
# number of list items in $a0
# seed initializes an initial random r by multiplying $sp with n
seed:
  # generate random r
  multu $sp,$a0   # random_addr * n
  mflo $t0        # random_number = random_addr * n
  # input and output in $t0 - absolute value
  sra $t1,$t0,31
  xor $t0,$t0,$t1
  sub $t0,$t0,$t1
  # end absolute value, in $t1 -1 after operation
  la $t1,r        # laod address of global value r
  sw $t0, 0($t1)  # r = random_number
  jr $ra          # jump back to caller

rand:
  # laod all constants
  lw $t1,const_a  # load value of const_a into register
  lw $t2,const_b  # load value of const_b into register
  lw $t3,const_m  # load value of const_m into register
  # calculate the random number $t1 = a, $t2 = b, $t3 = m
  lw $t4,r  # load r, $t4 = r
  multu $t1,$t4 # (a * r) in $t5
  mflo $t5
  # convert to absolute value
  # input and output in $t5 - absolute value
  sra $t1,$t5,31
  xor $t5,$t5,$t1
  sub $t5,$t5,$t1
  # end absolute value, in $t1 -1 after operation
  add $t6,$t5,$t2 # (a * r) + b in $t6
  div $t6,$t3     # ((a * r) + b) / m lo = quotient, hi = reminder
  mfhi $v0        #  ((a * r) + b) % m in $v0, since reminder in hi
  sw $v0,r      # save the new r value in global section
  jr $ra          # jump back to caller

main:
  li $a0,8 # set list item number as 6
  jal seed # init r value
  # print init r value
  lw $a0,r  # load r, $a0 = r for syscall
  li $v0, 1 # print_int for syscall
  syscall
  # print rand number
  jal rand # get rand number
  move $a0, $v0 # save rand value to print
  li $v0,1 # print_int
  syscall
  # clean exit
  li $v0, 10
  syscall
