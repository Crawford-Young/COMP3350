.data
	A: .word 21, 50, 63, 72, 0, 95, 11, 28, 4, 5, 16, 7 #importing the array
	N: .word 12 #importing length
    	prompt1: .asciiz "print an array \n"
    	prompt2: .asciiz "array length: "
    	prompt3: .asciiz "array elements: "
	eol: .asciiz " \n"
     	spacer: .asciiz ", "
.text
.globl main

main:
    	# Initialize $s0 and $s1 for array address and length
    	la   $s0, A           # $s0 contains the address of the array
    	lw $s1, N #load array length N to register $s3

    	# 1. show prompt information. 
    	li        $v0, 4	# system call #4 - print string
    	la        $a0, prompt1
    	syscall
    	li        $v0, 4	# system call #4 - print string
    	la        $a0, prompt2
    	syscall

    	# print N. When we load 1 into register $v0 and invoke syscall, MARS will print the integer in $a0
    	li        $v0, 1        # system call #1 - print int
    	move      $a0, $s1        # $a0 = $t3
    	syscall             
    
    	li        $v0, 4	# system call #4 - print string
    	la        $a0, eol
    	syscall   
    
    	li        $v0, 4	# system call #4 - print string
    	la        $a0, prompt3
    	syscall
    	
    	# sorting
    	move $a0, $s0
    	move $a1, $s1
    	j sort
    	sortReturn:

    	# 2. call printarray procedure
    	move $a0, $s0
    	move $a1, $s1
    	jal printarray
    
    	# 3. return 0 to end program
    	li        $v0, 10        # $v0 = 10
    	syscall

sort:
	move $t0, $a0
    	move $t1, $a1 # N=t1
    	addi $t2, $zero, 1 # i=1=t2
    	j loop1

loop1:
	bge $t2, $t1, sortReturn #when i>n the sort finishes and goes back to main
	addi $t3, $t2, -1 # j = i-1 = t3
	j loop2
	
loop2:
	blt $t3, $zero, exit_loop2 # if j<0 exit loop2
	move $a2, $t0
	move $a3, $t3
	jal getSpot
	move $t8, $a2
	lw $t4, 0($t8) # v[k]
	lw $t5, 4($t8) # v[k+1]
	bge $t5, $t4, exit_loop2  # if v[k] >= v[k+1] exit loop2
	move $a2, $t0
	move $a3, $t3
	j swap
	swapReturn:
	addi $t3, $t3, -1 #j--
	j loop2

exit_loop2:
	addi $t2, $t2, 1 #i++
	j loop1

swap: #parameters(int[] v, int k) swaps v[k] with v[k+1]
	move $t7, $a2
    	move $t6, $a3
    	jal getSpot
	move $t7, $a2 #t7 = v[k]
	lw $t4, 0($t7)
	lw $t5, 4($t7) #v[k+1]
	sw $t4, 4($t7) #v[k] = v[k+1]
	sw $t5, 0($t7) #v[k+1] = v[k]
	j swapReturn
	
getSpot: #parameters(int[] v, int k) sets a2 to v[k]
	move $t4, $a2
    	move $t5, $a3
    	loop:
    		addi $t4, $t4, 4 #increments through the array
		addi $t5, $t5, -1 #decrements k until the right spot
		bge $t5, $zero, loop 
	addi $t4, $t4, -4 #prevents the spot to be too far
	move $a2, $t4 #sets a2 to v[k]
	jr $ra

printarray:
    	move $t0, $a0
    	move $t1, $a1
    	printloop:
		lw $a0, 0($t0)	# Load value at address $t0	
		li $v0, 1
		syscall
    		li        $v0, 4	# system call #4 - print string
    		la        $a0, spacer
    		syscall
	
		addi $t0, $t0, 4	# Next element, i.e., increment offset by 4.
		addi $t1, $t1, -1	# decrement $t1
		bne $t1, $zero, printloop # check whether $t1 is equal to 0
		jr $ra
	
	
