'''
    SEL0615 - PROCESSAMENTO DIGITAL DE SINAIS
    EXERCÍCIO 1

    Nome: João Pedro Lopes de Melo
    nUSP: 15588950
'''

import numpy as np
import matplotlib.pyplot as plt

P = 1       # número de períodos
A = 1       # amplitude do sinal

freq_fundamental = float(input("Frequência Fundamental do Sinal: "))
freq_amostragem = float(input("Frequência de amostragem: "))

num_amostras = int((freq_amostragem / freq_fundamental) * P)

tempo_de_amostragem = 1 / freq_amostragem

vet_amostras = np.arange(num_amostras)

vet_tempo_discreto = vet_amostras * tempo_de_amostragem

sinal = A * np.sin(2 * np.pi * freq_fundamental * vet_tempo_discreto)


plt.figure(figsize=(10, 6))
plt.plot(vet_tempo_discreto, sinal, 'r-o')
plt.title(f'Senoide discreta (freq_fundamental={freq_fundamental}Hz, freq_amostragem={freq_amostragem}Hz)')
plt.xlabel('Tempo (s)')
plt.ylabel('Amplitude')
plt.grid(True)
plt.show()    # exibe o gráfico

