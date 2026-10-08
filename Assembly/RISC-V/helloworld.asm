		.data				# diretiva p/ início de seg de dados
		.align 0			# diretiva alinhar a memória em caractere
string:		.asciz "Hello World"		# diretiva para definir uma string
						
		.text				# diretiva p/ inicio do seg de texto
		.globl main			# diretiva p/ usar rotulo em outro prog

main:						# rótulo p/ ponto de entrada no processo
		.align 2			# alinha a memória para armazenar as instruções de 32 bits		
		addi a7, zero, 4		# código do serviço 4 (PrintString)
		la a0, string			# endereço do primeiro byte da string
		ecall				# chamada linux
		
		addi a7, zero, 10		# código do serviço 10 (Exit)
		ecall				# chamada linux
