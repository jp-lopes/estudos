#Codifique em Assembly RISC-V um programa que soma os valores de  
#um vetor de inteiros de tamanho definido no próprio programa. 
#Os dados do vetor também podem já estar definidos no código.

		.data
		.align 2
vetor:		.word 1,7,2,6,4
tam_vet:	.word 5

		.text
		.align 2
		.globl main

main:		
		la t0, vetor		#t0 tem o endereço do 1o byte do vetor
		la t1, tam_vet		
		lw t1, 0(t1)		#t1 é contador decrescente começa em tam_vet
		add s0, zero, zero	#s0 é acumulador de soma
		
loop:		
		beq t1, zero, fim_loop
		lw t2, 0(t0)		#t2 = conteúdo atual do vetor
		add s0, s0, t2		#s0 = s0 + t2
		
		addi t0, t0, 4		#vai para a próxima word do vetor
		addi t1, t1, -1		#o contador é decrementado
		j loop			#volta para o começo do loop
		
fim_loop:	
		add a0, zero, s0
		addi a7, zero, 1
		ecall			#printa a soma
		addi a7, zero, 10
		ecall			#encerra o programa

