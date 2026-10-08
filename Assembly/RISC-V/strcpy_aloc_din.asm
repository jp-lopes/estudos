#Função strcpy com Alocação Dinâmica
	.data
	.align 0
str_src:	.asciz "String a ser copiada"
str_dst:	.word	#variável ponteiro

	.text
	.align 2
	.globl main
	
main:	la a0, str_src
	jal strcpy
	#Printa a string copiada
	addi a7, zero, 4
	lw a0, str_dst
	ecall
	#Fim do programa
	addi a7, zero, 10
	ecall
	
strcpy:
	addi t1, a0, 0	#Copia o endereço de str_src para t1
	addi t0, zero, 0	 #Inicializa t0 com 0
	#Conta o numero de bytes de str_src e salva em t0
count_bytes_loop:
	lb t3, 0(t1)
	addi t1, t1, 1
	addi t0, t0, 1
	bne t3, zero, count_bytes_loop
	
	#Alocamos a memória necessária 
	addi t1, a0, 0	  #Copia o endereço de str_src para t1
	addi a7, zero, 9	  #Serviço 9 do ecall: alocar memoria heap
	addi a0, t0, 0    #Salva em a0 o número de bytes a serem alocados
	ecall
	addi a1, a0, 0    #Salva o endereço da memoria alocada em a1

	#Copiamos cada byte, até que t2 seja igual a 0
strcpy_loop:
	lb t2, 0(t1)
	sb t2, 0(a1)
	addi t1, t1, 1
	addi a1, a1, 1
	bne t2, zero, strcpy_loop
	#Faz com que str_dst aponte para o primeiro byte de memoria alocado
	la t3, str_dst
	sw a0, (t3)
	jr ra
	
	
