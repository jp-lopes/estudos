#Sorts the array using BubbleSort algorithm
		.data
		.align 0
str_before:	.asciz "Before BubbleSort: "
str_after:	.asciz "After BubbleSort: "
		.align 2
array:		.word 10,9,8,7,4,2,45,65,1,13,13,5
		
		.text
		.align 2
		.globl main
		
main:		
		#Prints "before" string
		addi a7, zero, 4
		la a0, str_before
		ecall
		#Go to "print_array" funtion
		jal print_array
		#Go to bubblesort function
		jal bubblesort
		#Prints '\n'
		addi a7, zero, 11
		addi a0, zero, 10
		ecall
		#Prints "after" string
		addi a7, zero, 4
		la a0, str_after
		ecall
		#Go to "print_array" funtion
		jal print_array
		#Exit program
		addi, a7, zero, 10
		ecall
	
#Prints the array	
print_array:	
		la t0, array			#t0 = the array adress
		addi t2, zero, 12		#t2 = the array length 

print_loop:	
		#Prints the array element
		lw t1, 0(t0)
		addi a7, zero, 1		
		add a0, zero, t1
		ecall
		
		addi t0, t0, 4			#t0 = t0 + 4
		addi t2, t2, -1			#t2 = t2 - 1 
		beq t2, zero, end_print_loop	#loop ends when t2 == 0
		#Prints ','
		addi a7, zero, 11
		addi a0, zero, 44
		ecall

		j print_loop

end_print_loop:	
		jr ra
	
#BubbleSort
bubblesort:	
		addi t3, zero, 11		#t3 = (array length - 1)
		
bs_main_loop:	
		beq t3, zero, end_bubblesort
		addi t4, zero, 11		#t4 = (array length - 1)
		la t0, array			#t0 = the array adress
		
bs_sec_loop:	
		beq t4, zero, end_main_loop 
		lw t1, 0(t0)			#t1 = array{i]
		lw t2, 4(t0)			#t2 = array[i+1]
		blt t2,t1,swap			#if t2<t1: go to swap
		j end_sec_loop			#else: go to end_sec_loop

swap:		
		sw t2, 0(t0)
		sw t1, 4(t0)
		
end_sec_loop:	
		addi t0, t0, 4
		addi t4, t4, -1
		j bs_sec_loop

end_main_loop:	
		addi t3, t3, -1
		j bs_main_loop

end_bubblesort:	
		jr ra
