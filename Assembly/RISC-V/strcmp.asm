#Codifique em Assembly RISC-V um programa que 
#implemente a funcionalidade da função strcmp()
		.data
		.align 0
str1:		.asciz "Hello World!"
str2:		.asciz "Hello World!"

		.text
		.align 2
		.globl main

main:		
		la a0, str1
		la a1, str2
		jal strcmp			#compara str1 e str2
		add a0, zero, a2
		addi a7, zero, 1
		ecall				#Printa 1 se a string é igual, 0 caso contrário
		
		addi a7,zero,10
		ecall				#Fim do programa

#Função strcmp
	#Entrada: a0 = str1, a1 = str2
	#Saída: a2 = 1 se igual, 0 se diferente
strcmp:
loop_strcmp:	
		lb t0, 0(a0)
		lb t1, 0(a1)
		bne t0,t1,diferente 		#se os bytes forem diferentes, sai do loop e são diferentes
		beq t0, zero, fim_loop		#se t0 == 0 e t1 == 0, o loop termina e são iguais
		addi a0, a0, 1	
		addi a1, a1, 1
		j loop_strcmp
fim_loop:	
		addi a2, zero, 1		#as strings são iguais, a2 = 1
		jr ra				#volta para o main
diferente:	
		addi a2, zero, 0		#as strings são diferentes, a2 = 0
		jr ra				#volta para o main