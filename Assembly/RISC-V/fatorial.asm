#Fatorial não recursivo
	.data
	.align 0
str1:	.asciz "Entre com um numero: "
str2:	.asciz "O fatorial de "
str3:	.asciz " é "

	.text
	.align 2
	.globl main
	
main:	addi a7, zero, 4		#serviço 4: print string
	la a0, str1		#salva o end do 1o bit da string em a0
	ecall			#printa a string
	addi a7, zero, 5		#serviço 5: ler int
	ecall			#lê int do teclado
	add s0, a0, zero		#salva o numero lido no registrador s0
	beqz s0, casezero	#se o numero for 0, 0! = 1
	add t0, s0, zero		#inicializa t0 como copia de s0 (n)
	addi s1, zero, 1
# n = s0 = t0, fat = s1
start:	beq t0, zero, end		#termina se n=0
	mul s1, s1, t0
	addi t0, t0, -1
	j start

casezero:
	addi s1,zero,1
	
end:	addi a7, zero, 4		#serviço 4: print string
	la a0, str2		#salva o end do 1o bit da string em a0
	ecall			#printa a string
	addi a7, zero, 1		#serviço 1: print int
	add a0, zero, s0		#salva o valor de n (inicial) em a0
	ecall			#printa o valor de n
	addi a7, zero, 4		#serviço 4: print string
	la a0, str3		#salva o end do 1o bit da string em a0
	ecall			#printa a string
	addi a7, zero, 1		#serviço 1: print int
	add a0, zero, s1		#salva o valor de fat em a0
	ecall			#printa o valor de fat
	li a7, 10		#serviço 10: exit
	ecall			#encerra o programa
	
	
		
	
	
	