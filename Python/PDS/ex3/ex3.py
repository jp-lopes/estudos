'''
    SEL0615 - PROCESSAMENTO DIGITAL DE SINAIS
    EXERCÍCIO 3

    Nome: João Pedro Lopes de Melo
    nUSP: 15588950
'''

import numpy as np
import matplotlib.pyplot as plt

# Dados
freq_fundamental = 50
amp_fundamental = 1.0

freq_harmonico_A = 300
amp_harmonico_A = 0.5

freq_harmonico_B = 500
amp_harmonico_B = 0.25

qtd_amostras_por_ciclo = 128
tempo_amostrado = 0.11

# Variaveis auxiliares
freq_amostragem = freq_fundamental * qtd_amostras_por_ciclo
num_periodos = tempo_amostrado * freq_fundamental 
num_amostras = int(freq_amostragem * tempo_amostrado)
tempo_de_amostragem = 1 / freq_amostragem
vet_amostras = np.arange(num_amostras)
vet_tempo_discreto = vet_amostras * tempo_de_amostragem
indice_plot = 1

# Sinal senoidal de 50Hz com amplitude 1
sinal = amp_fundamental * np.sin(2 * np.pi * freq_fundamental * vet_tempo_discreto)
# Soma de harmônico 300Hz com amplitude 0.5
sinal += amp_harmonico_A * np.sin(2 * np.pi * freq_harmonico_A * vet_tempo_discreto)
# Soma de harmônico 500Hz (10 * freq fundamental) com amplitude 0.25
sinal += amp_harmonico_B * np.sin(2 * np.pi * freq_harmonico_B * vet_tempo_discreto)

# Plota o sinal
plt.figure(indice_plot, figsize=(10, 6))
indice_plot += 1
plt.plot(vet_tempo_discreto, sinal, 'r')
plt.title(f'Sinal original ({freq_fundamental}Hz + {freq_harmonico_A}Hz + {freq_harmonico_B}Hz)')
plt.xlabel('Tempo (s)')
plt.ylabel('Amplitude')
plt.grid(True)

##########################################################################################################################

# a) Aplicação de DFT e obtenção do espectro de frequências
x = sinal
N = len(x)
X = [0j] * N

for m in range(N):
    soma = 0 + 0j
    for n in range(N): soma += x[n] * (np.cos(2 * np.pi * n * m / N) - 1j * np.sin(2 * np.pi * n * m / N))
    X[m] = soma

magnitudes = []
frequencias = []

for m in range(N // 2):
    freq = m * freq_amostragem / N
    if m == 0: amp = np.abs(X[m]) / N
    else: amp = (2 * np.abs(X[m])) / N
    frequencias.append(freq)
    magnitudes.append(amp)

print("a) Harmônicos Encontrados com DFT padrão:")
i = 0
for f, a in zip(frequencias, magnitudes):
    if a > 0.1:
        i += 1
        print(f"{i}. Frequência: {f:.2f}Hz, Amplitude: {a:.2f}")

# Plota Espectro de Frequência da DFT padrão
plt.figure(indice_plot, figsize=(10, 6))
indice_plot += 1
plt.stem(frequencias, magnitudes)
plt.title("Espectro de Frequências - DFT padrão")
plt.xlabel("Frequência (Hz)")
plt.ylabel("Magnitude")
plt.grid(True)
plt.xlim(0, 800) # melhora visualiação limitando o eixo X até 800 Hz

##########################################################################################################################

# b) Cálculo da energia para a banda de frequências de 0 Hz a 1 kHz 
# (energia do sinal inteiro, já que a maior freq é 500Hz)

def calcular_energia_do_sinal(sinal):
    energia_sinal = 0
    for valor in sinal:
        energia_sinal += valor**2
    return energia_sinal

print(f'\nb) Energia do Sinal: {calcular_energia_do_sinal(sinal):.2f}')

##########################################################################################################################

# c) Aplicação de DFT janelada

energias_sinais_janelados = []  # guarda a energia dos sinais janelados nessa lista para o item d)

# Função de DFT janelada para evitar repetição de código
def DFT_Janelada(funcao_janela, nome_janela):
    global x, sinal, X, N, magnitudes, frequencias, indice_plot, energias_sinais_janelados

    w = funcao_janela(N)
    x = sinal * w   # aplica janela ao sinal
    X = [0j] * N

    for m in range(N):
        soma = 0 + 0j
        for n in range(N): soma += x[n] * (np.cos(2 * np.pi * n * m / N) - 1j * np.sin(2 * np.pi * n * m / N))
        X[m] = soma

    magnitudes.clear()
    frequencias.clear()

    for m in range(N // 2):
        freq = m * freq_amostragem / N
        if m == 0: amp = (np.abs(X[m]) / N)
        else: amp = ((2 * np.abs(X[m])) / N)
        frequencias.append(freq)
        magnitudes.append(amp)

    print(f"Harmônicos Encontrados com DFT janelada ({nome_janela}):")
    i = 0
    for f, a in zip(frequencias, magnitudes):
        if a > 0.1:
            i += 1
            print(f"{i}. Frequência: {f:.2f}Hz, Amplitude: {a:.2f}")
    print()
    
    energias_sinais_janelados.append((nome_janela, calcular_energia_do_sinal(x)))

    # Plota Espectro de Frequência da DFT janelada
    plt.figure(indice_plot, figsize=(10, 6))
    indice_plot += 1
    plt.stem(frequencias, magnitudes)
    plt.title(f"Espectro de Frequências - DFT janelada ({nome_janela})")
    plt.xlabel("Frequência (Hz)")
    plt.ylabel("Magnitude")
    plt.grid(True)
    plt.xlim(0, 800)

# Fórmulas das funções janela: https://numpy.org/doc/2.4/reference/routines.window.html

print('\nc) Aplicando DFT Janelada no sinal:')
DFT_Janelada(np.hanning, "Hann")
DFT_Janelada(np.hamming, "Hamming")
DFT_Janelada(np.ones, "Retangular") # np.ones(N) retorna um array [1]*N, assim como seria a janela retangular
DFT_Janelada(np.blackman, "Blackman")

##########################################################################################################################
# d) Energias dos Sinais Janelados (calculados na funcao DFT_Janelada)
print("\nd) Energia dos Sinais Janelados:")
for (nome_janela, energia) in energias_sinais_janelados:
    print(f'Janela {nome_janela}: {energia:.2f}')

# Exibe gráficos
plt.show()