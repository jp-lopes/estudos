#Trabalho de SSC0902 - Organização e Arquitetura de Computadores
#Grupo:
	#Caio Cesar Trentin de Assis 	- 15674233
	#Isabela Sakomura Borges 	- 15460673
	#João Pedro Lopes de Melo 	- 15588950
	#Mariana do Nascimento Ferreira - 15582241

#Mochila do Aventureiro
		.data
		.align 0
str_BemVindo:	.asciz "Bem vindo aventureiro à sua mochila mágica, aqui todos os seus itens estarão seguros!\n"
str_Opcoes:	.asciz "\nOpções:\n1.Adicionar item\n2.Remover item\n3.Listar inventário\n4.Buscar item\n5.Sair\nDigite uma opção: "		
str_OpcaoInv:	.asciz "\nErro, aventureiro! Digite uma opção válida!\n"
str_ID:		.asciz "\nAventureiro, qual o ID do item? "
str_Listar:	.asciz "\nEssa é a sua mochila, aventureiro: \n"
str_Adicionado:	.asciz "\nExcelente! Seu novo item foi guardado na mochila, já pode voltar para a sua aventura!\n"
str_Removido:	.asciz "\nExcelente! Seu item foi usado!\n"
str_Vazia:	.asciz "\nOps! Sua mochila está vazia! =(\n"
str_Encontrado:	.asciz "\nEba! Você tem esse item na mochila! =D\n"
str_nEncontrado:.asciz "\nOps! Você não tem esse item... =(\n"
str_Sair:	.asciz "\nAdeus, aventureiro, até a próxima! =D\n"
		.align 2
lista:		.word 0		#Ponteiro para o início da lista, iniciado em 0
		
		.text
		.align 2		
		.globl main

main:		
		#Definições:
		addi s1, zero, 1
		addi s2, zero, 2
		addi s3, zero, 3
		addi s4, zero, 4
		addi s5, zero, 5
		#Printar o menu do jogo:
		addi a7, zero, 4
		la a0, str_BemVindo
		ecall
main_loop:	
		#Printar as opções do aventureiro:
		addi a7, zero, 4
		la a0, str_Opcoes
		ecall
		#Ler uma opção do teclado:
		addi a7, zero, 5
		ecall
		#Ir para a opção escolhida:
		beq a0, s1, AdicionarItem_1
		beq a0, s2, RemoverItem_2
		beq a0, s3, ListarInventario_3
		beq a0, s4, BuscarItem_4
		beq a0, s5, Sair_5
		#Se não entrar em nenhuma opção, printa mensagem de erro:
		addi a7, zero, 4
		la a0, str_OpcaoInv
		ecall
		#Voltar pro começo do loop:
		j main_loop

#Opção 1: Adicionar Item
AdicionarItem_1:
		#Printar mensagem de ID:
		addi a7,zero,4
		la a0, str_ID
		ecall
		#Ler um ID do teclado:
		addi a7, zero, 5
		ecall
		#Salvar o ID lido em s0:
		add s0, zero, a0
		#Inserir na lista:
		  #Alocar 8 bits da Heap:
		addi a7, zero, 9
		addi a0, zero, 8
		ecall				#a0 tem o endereço do novo nó
		  #Carregar o início da lista em t0:
		lw t0, lista			#salva o endereço do começo da lista em t0
		sw s0, 0(a0)			#salva o ID no novo nó
		sw t0, 4(a0)			#salva o endereço do começo da lista no novo nó
		  #O novo nó vira o começo da lista:
		la t0, lista			
		sw a0, 0(t0)
		#Printar mensagem de sucesso:
		addi a7, zero, 4
		la a0, str_Adicionado
		ecall		
		#Voltar para o começo do programa:
		j main_loop

#Opção 2: Remover Item
RemoverItem_2:
		#Carregar em t0 o começo da lista:
		lw t0, lista
		beq t0, zero, erro_remocao
		#Pegar o próximo nó da lista:
		lw t0, 4(t0)
		#O próximo nó vira o novo começo da lista:
		la t1, lista
		sw t0, 0(t1)
		#Printar mensagem de sucesso:
		addi a7, zero, 4
		la a0, str_Removido
		ecall
		#Voltar para o começo do programa:
		j main_loop
		
erro_remocao:	
		#Printar mensagem de mochila vazia:
		addi a7, zero, 4
		la a0, str_Vazia
		ecall
		#Voltar para o começo do programa:
		j main_loop
		
#Opção 3: Listar Inventário
ListarInventario_3:
		#Carregar em t0 o começo da lista:
		lw t0, lista
		beq t0, zero, erro_listar
		#Printar mensagem de listar inventário:
		addi a7, zero, 4
		la a0, str_Listar
		ecall

loop_opc3:	
		beq t0, zero, fim_loop_opc3	#se t0=0 o loop termina
		#Carregar o ID em a0 e printar 
		lw a0, 0(t0)			
		addi a7, zero, 1
		ecall
		#Printar '\n'
		addi a0, zero, '\n'
		addi a7, zero, 11
		ecall
		#Ir para o próximo nó da lista
		lw t0, 4(t0)
		j loop_opc3

fim_loop_opc3:	
		#Voltar para o começo do programa:
		j main_loop

erro_listar:	
		#Printar mensagem de mochila vazia:
		addi a7, zero, 4
		la a0, str_Vazia
		ecall
		#Voltar para o começo do programa:
		j main_loop

#Opção 4: Buscar item
BuscarItem_4:	
		#Printar mensagem de ID:
		addi a7,zero,4
		la a0, str_ID
		ecall
		#Ler um ID do teclado:
		addi a7, zero, 5
		ecall
		#Salvar o ID a ser buscado em s0:
		add s0, zero, a0		
		#Carregar em t0 o começo da lista:
		lw t0, lista

loop_busca:	
		beq t0, zero, fim_loop_busca	#se t0==0, o item não foi encontrado
		lw t1, 0(t0)			#carrega em t1 o ID do item atual
		beq t1, s0, encontrado		#se t1==s0, desvia do loop
		lw t0, 4(t0)			#caso contrário, vai para o próximo ID da lista
		j loop_busca
		
fim_loop_busca: 
		#Printar mensagem de não encontrado:
		addi a7,zero,4
		la a0, str_nEncontrado
		ecall
		#Voltar para o começo do programa:
		j main_loop
		
encontrado:	
		#Printar mensagem de encontrado:
		addi a7,zero,4
		la a0, str_Encontrado
		ecall
		#Voltar para o começo do programa:
		j main_loop

#Opção 5: Sair do jogo
Sair_5:		
		#Printar mensagem de adeus:
		addi a7, zero, 4
		la a0, str_Sair
		ecall
		#Chamar serviço 10 (Exit):
		addi a7, zero, 10
		ecall
