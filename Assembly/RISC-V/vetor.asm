#Percorre o vetor e printa cada elemento, separado por vírgula
	.data
	.align 2
vetor:	.word 115,9,4,3,1,23,45,31,1
	
	.text
	.align 2
	.globl main

main:	
	la t0, vetor  		#t0 recebe endereco do primeiro byte do vetor
	addi t3, zero, 9 	#contador decrescente

loop:	
	lw t1, 0(t0)		#t1 recebe conteudo do primeiro byte do vetor
	addi t0, t0, 4		#vai pro próximo índice do vetor (+4 bytes)
	addi t3, t3, -1		#decrementa o contador
	#Printa o elemento do vetor
	add a0, zero, t1
	addi a7, zero, 1
	ecall
	#Testa condição de parada
	beq t3,zero, fim_loop
	#Printa virgula e volta pro começo do loop
	addi a0, zero, 44	#44 é o código ASCII de ','
	addi a7, zero, 11
	ecall
	j loop
	
fim_loop:
	#fim do programa
	addi a7, zero, 10
	ecall