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
  multu $sp,$a0   # random_addr * n
  mflo $t0        # random_number = random_addr * n
  la $t1,r        # laod address of global value r
  sw $t0, 0($t1)  # r = random_number
  jr $ra          # jump back to caller

rand:
  # laod all constants
  la $t0,const_a  # get address of const_a
  lw $t1, 0($t0)  # load value of const_a into register
  la $t0,const_b  # get address of const_b
  lw $t2, 0($t0)  # load value of const_b into register
  la $t0,const_m  # get address of const_m into register
  lw $t3, 0($t0)  # load value of const_m into register
  # calculate the random number $t1 = a, $t2 = b, $t3 = m
  la $t0,r        # get address of global r register
  lw $t4, 0($t0)  # load r, $t4 = r
  mul $t5,$t1,$t4 # (a * r) in $t5
  add $t6,$t5,$t2 # (a * r) + b in $t6
  div $t6,$t3     # ((a * r) + b) / m lo = quotient, hi = reminder
  mfhi $v0        #  ((a * r) + b) % m in $v0, since reminder in hi
  jr $ra          # jump back to caller
