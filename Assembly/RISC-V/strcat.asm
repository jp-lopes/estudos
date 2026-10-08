#Codifique em Assembly RISC-V um programa que implemente 
#a funcionalidade da função strcat()

		.data
		.align 0
str_dst:	.asciz "Hello"
str_src:	.asciz " World!"

		.text
		.align 2
		.globl main
		
main:		
		la a0, str_dst
		la a1, str_src
		jal strcat
		addi a7, zero, 4
		ecall				#printa a string concatenada
		addi a7, zero, 10
		ecall				#encerra o programa
		
#Função strcat: 
	#Entrada: a0 = destino, a1 = fonte
	#Saída: a0 = destino + fonte

strcat:
		addi sp, sp, -4
		sw ra, 0(sp)			#salva ra na pilha
		add s0, zero, a0		#salva str_dst em s0
		add s1, zero, a1		#salva str_src em s1
		
		add a0, zero, s0
		jal count_bytes			#conta os bytes de str_dst sem '\0'
		add s2, zero, a1		#salva em s2 o nº de bytes de str_dst
		
		add a0, zero, s1
		jal count_bytes			#conta os bytes de str_src sem '\0'
		add s3, zero, a1		#salva em s3 o nº de bytes de str_src
		
		add a0, s2, s3
		addi a0, a0, 1			#aloca 1 byte a mais para o '\0'
		addi a7, zero, 9
		ecall				#aloca bytes p/ a nova string
		
		add s4, zero, a0		#salva em s4 a nova string
		add t0, zero, s4		#t0 é cópia de s4
		
loop1_strcat:
		lb t1, 0(s0)
		beq t1, zero, fim_loop1		#não copia o '\0'
		sb t1, 0(t0)
		addi t0, t0, 1
		addi s0, s0, 1
		j loop1_strcat
		
fim_loop1:
loop2_strcat:
		lb t1, 0(s1)
		beq t1, zero, fim_loop2		#não copia o '\0'
		sb t1, 0(t0)
		addi t0, t0, 1
		addi s1, s1, 1
		j loop2_strcat

fim_loop2:
		sb zero, 0(t0)			#salva o '\0' no último byte da nova string
		add a0, zero, s4		#salva em a0 a nova string
		lw ra, 0(sp)			#desempilha ra
		addi sp, sp, 4			
		jr ra				#volta p/ o main
		
#Função count_bytes: conta bytes da string sem o '\0'
	#Entrada: a0 = string
	#Saída: a1 = nº de bytes

count_bytes:	
		add a1, zero, zero
loop_cb:	
		lb t0, 0(a0)
		beq t0, zero, fim_loop_cb
		addi a1, a1, 1
		addi a0, a0, 1
		j loop_cb
fim_loop_cb:
		jr ra
	
	
