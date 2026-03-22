'''
    SEL0615 - PROCESSAMENTO DIGITAL DE SINAIS
    EXERCÍCIO 2

    Nome: João Pedro Lopes de Melo
    nUSP: 15588950
'''

import numpy as np
import csv
import matplotlib.pyplot as plt

vet_amostras = []
vet_tempo = []

# Leitura dos arquivos
with open('Sinal.txt', 'r',  encoding='utf-8') as arq_sinal:
    leitor_csv = csv.reader(arq_sinal, delimiter=';')
    for linha in leitor_csv:
        for valor in linha:
            vet_amostras.append(float(valor))
    
with open('TimeStamp.txt', 'r',  encoding='utf-8') as arq_tempo:
    leitor_csv = csv.reader(arq_tempo, delimiter=';')
    for linha in leitor_csv:
        for valor in linha:
            vet_tempo.append(float(valor))

# Determinação da frequência de amostragem 
tempo_entre_amostras = vet_tempo[1] - vet_tempo[0]
freq_amostragem = round(1 / tempo_entre_amostras)
print(f'Frequência de amostragem do sinal: {freq_amostragem}Hz')

# DFT
x = vet_amostras
N = len(x)
X = [0j] * N

for m in range(N):
    soma = 0 + 0j

    for n in range(N):
        soma += x[n] * (np.cos(2 * np.pi * n * m / N) - 1j * np.sin(2 * np.pi * n * m / N))

    X[m] = soma

# Determinação de frequências e amplitudes
magnitudes = []
frequencias = []

for m in range(N // 2):
    freq = m * freq_amostragem / N
    
    if m == 0:
        amp = np.abs(X[m]) / N
    else:
        amp = (2 * np.abs(X[m])) / N
    
    frequencias.append(freq)
    magnitudes.append(amp)

print("Harmônicos Encontrados:")
i = 0
for f, a in zip(frequencias, magnitudes):
    if a > 0.1:
        i += 1
        print(f"{i}. Frequência: {f:.2f}Hz, Amplitude: {a:.2f}")


# Espectro de Frequência
plt.figure(figsize=(10, 4))
plt.stem(frequencias, magnitudes)
plt.title("Espectro de Frequência")
plt.xlabel("Frequência (Hz)")
plt.ylabel("Magnitude")
plt.grid(True)
plt.show()