#Fatorial com função recursiva
		.data
		.align 0
str1:		.asciz "Digite o número: "
str2:		.asciz "O fatorial é: "
		
		.text
		.align 2
		.globl main
		
main:		addi a7, zero, 4
		la a0, str1
		ecall
		
		addi a7, zero, 5
		ecall
		
		jal fat
		
		addi a7, zero, 4
		la a0, str2
		ecall
		
		addi a7, zero, 1
		add a0, zero, a1
		ecall
		
		addi a7, zero, 10
		ecall

#Função RECURSIVA que calcula fatorial, entrada = a0, saída = a1		
fat:		#Empilhar a0 e ra				#int fat(int n){
		addi sp, sp, -8					#    if(n==0) return 1;
		sw a0, 0(sp)					#    return(fat(n-1)*n);
		sw ra, 4(sp)					#}
		beq a0, zero, retorna_1
		#Chama a função novamente
		addi a0, a0, -1
		jal fat
		#Multiplicação
		addi a0, a0, 1
		mul a1, a1, a0
		j retorna_fat
		
retorna_1:	addi a1, zero, 1
		#Desempilhar
retorna_fat:	lw a0, 0(sp)
		lw ra, 4(sp)
		addi sp, sp, 8
		jr ra