#Codifique em Assembly RISC-V um programa que lê uma string fornecida pelo usuário, 
#inverte e imprime ela invertida.
		.data
		.align 0
str_src:	.asciz "desserts"
		.align 2
str_dst:	.word				#ponteiro p/ a nova string
		
		.text
		.align 2
		.globl main

main:		
		la t0, str_src			#t0 tem o end. do 1o byte da str_src
		add s0, zero, zero		#s0 é contador de bytes

loop_contagem:
		lb t1, 0(t0)			#t1 é o char atual
		beq t1, zero, fim_contagem 	#'\0' não entra na contagem
		addi s0, s0, 1			#o contador é incrementado
		addi t0, t0, 1			#vai p/ o próximo char
		j loop_contagem			#volta p/ o começo do loop

fim_contagem:
		addi a0, s0, 1			#aloca 1 byte a mais para o '\0'
		addi a7, zero, 9		
		ecall				#aloca bytes p/ a nova string
		la t0, str_dst
		sw a0, 0(t0)			#guarda o end. de memória alocada em str_dst
		#Criação da nova string:
		la t0, str_src			#t0 tem o end. 1o byte da str_src
		add t0, t0, s0			
		addi t0, t0, -1			#agora t0 está no fim da string, antes do '\0'
		lw t1, str_dst			#t1 tem o end. 1o byte da str_dst
		
loop_inverte_string:
		beq s0, zero, fim_inverte_string
		lb t2, 0(t0)
		sb t2, 0(t1)
		addi t0, t0, -1			#volta 1 byte da str_src
		addi t1, t1, 1			#avança 1 byte da str_dst
		addi s0, s0, -1			#o contador é decrementado
		j loop_inverte_string

fim_inverte_string:
		sb zero, 0(t1)			#adiciona '\0' no fim de str_dst
		addi a7, zero, 4
		la a0, str_src
		ecall				#printa str_src
		addi a7, zero, 11
		addi a0, zero, '\n'		
		ecall				#printa '\n'
		addi a7, zero, 4
		lw a0, str_dst
		ecall				#printa a str_dst
		addi a7, zero, 10
		ecall				#encerra o programa
		
		
		
		
		
		
		
		
		
						