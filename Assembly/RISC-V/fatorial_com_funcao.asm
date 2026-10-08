#Fatorial com função
		.data
		.align 0
str1:		.asciz "Digite o número: "
str2:		.asciz "O fatorial é: "
		
		.text
		.align 2
		.globl main
		
main:		addi a7, zero, 4
		la a0, str1
		ecall
		
		addi a7, zero, 5
		ecall
		
		jal fat
		
		addi a7, zero, 4
		la a0, str2
		ecall
		
		addi a7, zero, 1
		add a0, zero, a1
		ecall
		
		addi a7, zero, 10
		ecall

#Função que calcula fatorial, entrada = a0, saída = a1		
fat:		addi a1, zero, 1
		add t1, zero, a0
		
loop:		beq, t1, zero, fim_loop
		mul a1, a1, t1
		addi t1, t1, -1
		j loop

fim_loop:	jr ra
