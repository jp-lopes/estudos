#Lê um número do teclado
#Se for positivo imprime: “Hello World! ++ <num>”
#Se for negativo imprime: “Hello World! -- <num>”

		.data
		.align 0
str1:		.asciz "Hello World! ++ "
str2:		.asciz "Hello World! -- "
		
		.text
		.align 2 		#instruções de 2^2 bytes = 4 bytes = 32 bits
		.globl main
		
main:		addi a7, zero, 5 	#serviço 5: ler int do teclado, salva o int lido no registrador a0
		ecall
		add s0 ,a0, zero 	#salvando o int lido do teclado no registrador s0
		blt s0,zero,print_neg 	#Branch if less than: se s0<0, vai para o label print_neg
		
		#Mensagem caso o valor lido seja positivo
		addi a7, zero, 4	#serviço 4: print string
		la a0, str1		#salva em a0 o endereço do primeiro byte da string a ser printada
		ecall			#printa a string
		j the_end		#jump incondicional, sempre irá para the_end 

		#Mensagem caso o valor lido seja negativo
print_neg:	addi a7, zero, 4	#serviço 4: print string
		la a0, str2		#salva em a0 o endereço do primeiro byte da string a ser printada
		ecall			#printa a string
		
		#Print comum aos dois casos:
the_end:		addi a7, zero, 1	#serviço 1: print int
		add a0, s0, zero		#salva o número lido do teclado em a0
		ecall			#printa o int lido
		
		#Fim do programa
		li a7, 10		#serviço 10: exit
		ecall			#encerra o programa
	



