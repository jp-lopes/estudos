		.data
		.align 0
str_src:	.asciz "Hello World"
str_dst:	.space 20
		
		.text
		.align 2
		.globl main

main:		addi a7, zero, 5
		ecall
		add s1, zero, a0
		la a0, str_src
		la a1, str_dst
		jal strncpy
		addi a7, zero, 4
		la a0, str_dst
		ecall
		addi a7, zero, 10
		ecall

#Função strncpy:
	#Entrada: a0 = src, a1 = dst, s1 = nº bytes
	#Saída: não tem
strncpy:
		add t0, zero, zero #t0 é contador de iterações do loop
loop_strncpy:
		beq t0, s1, fim_loop_strncpy #o loop termina se t0 == s1
		lb t1, 0(a0) #t1 = byte da string fonte
		sb t1, 0(a1) #guarda t1 no byte da string destino
		addi a0, a0, 1
		addi a1, a1, 1 #avança 1 byte nas duas strings
		addi t0, t0, 1 #incrementa o contador
		j loop_strncpy #volta para o começo do loop
fim_loop_strncpy:
		sb zero, 0(a1) #salva '\0' no fim de str_dst
		jr ra