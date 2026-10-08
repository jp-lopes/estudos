org 0000h

; configura estado inicial do 8051
setup:			setb P0.7 ; CS do Decoder
				clr P3.4 ; A1 do Decoder
				clr P3.3 ; A0 do Decoder
				acall display_1 ; estado inicial do LED em 1 decimal

; checa valor das chaves constantemente 
main_loop:		jnb P2.0, cont_asc ; chave #0 pressionada, vai para contagem ascendente
				jnb P2.1, cont_desc ; chave #1 pressionada, vai para contagem descendente
				sjmp main_loop ; se nenhuma chave estiver pressionada volta para label main e checa novamente		

; contador ascendente, muda o led de acordo com o estado atual dele usando como referência o valor de R7
cont_asc:
loop_asc:		
				cjne R7, #000h, chk1_asc ; se R7!=0 verifica se R7=1
				acall display_1 ; caso contrario (R7=0) atualiza display para 1
				sjmp fim_loop_asc
chk1_asc:		
				cjne R7, #001h, chk2_asc ; se R7!=1 verifica se R7=2
				acall display_2 ; caso contrario (R7=1) atualiza display para 2
				sjmp fim_loop_asc
chk2_asc:		
				cjne R7, #002h, chk3_asc ; se R7!=2 verifica se R7=3
				acall display_3 ; caso contrario (R7=2) atualiza display para 3
				sjmp fim_loop_asc
chk3_asc:		
				cjne R7, #003h, chk4_asc ; se R7!=3 verifica se R7=4
				acall display_4 ; caso contrario (R7=3) atualiza display para 4
				sjmp fim_loop_asc
chk4_asc:		
				cjne R7, #004h, chk5_asc ; se R7!=4 verifica se R7=5
				acall display_5 ; caso contrario (R7=4) atualiza display para 5
				sjmp fim_loop_asc
chk5_asc:		
				cjne R7, #005h, chk6_asc ; se R7!=5 verifica se R7=6
				acall display_6 ; caso contrario (R7=5) atualiza display para 6
				sjmp fim_loop_asc
chk6_asc:		
				cjne R7, #006h, chk7_asc ; se R7!=6 verifica se R7=7
				acall display_7 ; caso contrario (R7=6) atualiza display para 7
				sjmp fim_loop_asc
chk7_asc:		
				cjne R7, #007h, chk8_asc ; se R7!=7, reinicia contador
				acall display_8 ; caso contrario (R7=7) atualiza display para 8
				sjmp fim_loop_asc
chk8_asc:		
				; se passou por todas as comparacões, o valor só pode ser 8 ou 9, então reseta contagem
				acall display_0 
				sjmp fim_loop_asc
fim_loop_asc:
				; delay para o contador ascendente, com dois loops de 100 iterações
delay_menor:	mov R0, #064h ; salva 100 em R0	
loop1_menor:	mov R1, #064h ; salva 100 em R1
loop2_menor:	jb P2.1, continua_menor ; se a chave 1 não foi pressionada continua delay 
				ljmp cont_desc ; caso contrario (chave 1 pressionada) muda para modo descendente
continua_menor:	djnz R1, loop2_menor ; decrementa R1 até 0 (de 1 por 1)
				djnz R0, loop1_menor ; decremente R0 até 0 de 1 por 1 e depois volta pra loop1_menor
				; apos o delay, retorna para o inicio do loop do contador
				sjmp loop_asc


; contador descendente, muda o led de acordo com o estado atual dele usando como referência o valor de R7
cont_desc :
loop_desc:		
				cjne R7, #009h, chk8_desc ; se R7!=9 verifica se R7=8
				acall display_8 ; caso contrario (R7=9) atualiza display para 8
				sjmp fim_loop_desc
chk8_desc:		
				cjne R7, #008h, chk7_desc ; se R7!=8 verifica se R7=7
				acall display_7 ; caso contrario (R7=8) atualiza display para 7
				sjmp fim_loop_desc
chk7_desc:		
				cjne R7, #007h, chk6_desc ; se R7!=7 verifica se R7=6
				acall display_6 ; caso contrario (R7=7) atualiza display para 6
				sjmp fim_loop_desc
chk6_desc:		
				cjne R7, #006h, chk5_desc ; se R7!=6 verifica se R7=5
				acall display_5 ; caso contrario (R7=6) atualiza display para 5
				sjmp fim_loop_desc
chk5_desc:		
				cjne R7, #005h, chk4_desc ; se R7!=5 verifica se R7=4
				acall display_4 ; caso contrario (R7=5) atualiza display para 4
				sjmp fim_loop_desc
chk4_desc:		
				cjne R7, #004h, chk3_desc ; se R7!=4 verifica se R7=3
				acall display_3 ; caso contrario (R7=4) atualiza display para 3
				sjmp fim_loop_desc
chk3_desc:		
				cjne R7, #003h, chk2_desc ; se R7!=3 verifica se R7=2
				acall display_2 ; caso contrario (R7=3) atualiza display para 2
				sjmp fim_loop_desc
chk2_desc:		
				cjne R7, #002h, chk1_desc ; se R7!=2, R7=1 ou R7=0
				acall display_1 ; caso contrario (R7=2) atualiza display para 1
				sjmp fim_loop_desc
chk1_desc:
				; se passou por todas as comparacões, o valor só pode ser 1 ou 0, então reseta contagem
				acall display_9 
				sjmp fim_loop_desc
fim_loop_desc:
				; delay para o contador descendente, com dois loops de 255 iterações
delay_maior:	mov R0, #0FFh ; salva 255 em R0	
loop1_maior:	mov R1, #0FFh ; salva 255 em R1
loop2_maior:	jb P2.0, continua_maior ; se a chave 0 não foi pressionada continua delay 
				ljmp cont_asc ; caso contrario (chave 0 pressionada) muda para modo ascendente
continua_maior:	djnz R1, loop2_maior ; decrementa R1 até 0 (de 1 por 1)
				djnz R0, loop1_maior ; decremente R0 até 0 de 1 por 1 e depois volta pra loop1_maior
				; apos o delay, retorna para o inicio do loop do contador
				sjmp loop_desc 

; tabela do contador
display_0:	mov P1,#11000000b 	; 0 decimal
			mov R7, #000h 		; salva estado atual do led em R7
			ret
display_1:	mov P1,#11111001b 	; 1 decimal
			mov R7, #001h 		; salva estado atual do led em R7
			ret
display_2:	mov P1,#10100100b 	; 2 decimal
			mov R7, #002h 		; salva estado atual do led em R7
			ret	
display_3:	mov P1,#10110000b 	; 3 decimal
			mov R7, #003h 		; salva estado atual do led em R7
			ret	
display_4: 	mov P1,#10011001b 	; 4 decimal
			mov R7, #004h 		; salva estado atual do led em R7
			ret
display_5: 	mov P1,#10010010b 	; 5 decimal
			mov R7, #005h 		; salva estado atual do led em R7
			ret
display_6: 	mov P1,#10000011b 	; 6 decimal
			mov R7, #006h 		; salva estado atual do led em R7
			ret
display_7: 	mov P1,#11111000b 	; 7 decimal
			mov R7, #007h 		; salva estado atual do led em R7
			ret
display_8: 	mov P1,#10000000b 	; 8 decimal
			mov R7, #008h 		; salva estado atual do led em R7
			ret
display_9: 	mov P1,#10011000b	; 9 decimal
			mov R7, #009h 		; salva estado atual do led em R7
			ret	 

end
