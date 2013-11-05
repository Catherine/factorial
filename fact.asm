#Catherine Patchell - 9/18/2013
		
		.data
initialprompt:	.word prompt1
finalpromptbeg:	.word prompt2
finalpromptend: .word prompt3
prompt1: 	.asciiz "Positive Integer: "
prompt2:	.asciiz "The value of factorial("
prompt3:	.asciiz ") is: "

		.text
main:		#printf("Positive integer: ");
		#scanf("%d", &number);
		la 	$t0, initialprompt	#load address of string
		lw 	$a0, 0($t0)		#Given address in $t0, load its value into $a0
		li 	$v0, 4			#system call code for print_string
		syscall				#make system call
		
		li 	$v0, 5			#system call code for read_int
		syscall				#make system call
		move $t0, $v0			#move value user gave into $t0
		
		#printf("The value of 'factorial(%d)' is:
		la      $t1, finalpromptbeg	#load address of string to $t1
  		lw      $a0, 0($t1)       	#Given address in $t1, load its value into $a0
 		li      $v0, 4           	#system call code for print_string
  		syscall                  	#make system call
  		
  		move 	$a0, $t0		#move user's value into $a0 for use in syscall
		li 	$v0, 1			#system call code for print_int
		syscall
  		
  		la      $t1, finalpromptend	#load address of string to $t1
  		lw      $a0, 0($t1)       	#Given address in $t1, load its value into $a0
 		li      $v0, 4           	#system call code for print_string
  		syscall                  	#make system call

		move 	$a0, $t0		#move $t0 to $a0 to be used as arg in factorial
		jal 	factorial		#jump and link to factorial
		
		#return here with final value and print
		move 	$a0, $v0
		li 	$v0, 1			#system call code for print_int
		syscall				#make system call	
		# return 0;
  		li 	$v0, 10		# Restore $ra from stack
  		syscall		

factorial:	#if (x == 0)
		move $t0, $a0
		bne $t0, $zero, next 		#branch if $a0 is not equal to zero
     		beq $v0, $zero, notToOne	#check to see if $v0 equals 0, branch if true
     		#return 1
     		li $v0, 1			#set $v0 to 1
      		jr $ra 
notToOne:	jr $ra
		#else {return x*factorial(x-1);
next: 		addi $sp, $sp, -12 		#extend stack: -12 because stack grows downwards
      		sw $ra, 0($sp) 			#save $ra on stack
      		sw $t0, 4($sp) 			#save value on stack
      		addi $a0, $t0, -1 		#$t0-1 and save as arg for factorial's recursion
      		jal factorial 			#jump and link to factorial (recursion)
      		
      		lw $t0, 4($sp) 			#load value/word from stack into $t0
      		mul $v0, $v0, $t0 		#multiply values
      		lw $ra, 0($sp) 			#restore $ra from stack
      		addi $sp, $sp, 12 		#remove added spaces from stack
      		jr $ra 
