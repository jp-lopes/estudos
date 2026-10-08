#Função strcpy
	.data
	.align 0
str_src:	.asciz "String a ser copiada"
str_dst:	.space 21  #Reserva 21 bytes na memória

	.text
	.align 2
	.globl main
	
main:	la a0, str_src
	la a1, str_dst
	#Vai para a função strcpy
	jal strcpy #equivalente a "jal ra, strcpy" (ra = return adress)
	#Printa a string copiada:
	addi a7, zero, 4
	la a0, str_dst
	ecall
	#Fim do programa
	addi a7, zero, 10
	ecall

strcpy:
strcpy_loop:
	lb t0, 0(a0)	#Salva o byte de str_src em t0
	sb t0, 0(a1)	#Guarda o byte salvo em str_dst
	#Vai para o próximo índice
	addi a0,a0,1
	addi a1,a1,1
	#Volta para o começo do loop se a0 != 0 (ascii para '\0')
	bne t0, zero, strcpy_loop
	#Caso contrário, retorna para o main
	jr ra
	
	
	
	
	
	
	
	
	