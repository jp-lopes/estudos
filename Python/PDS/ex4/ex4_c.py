import numpy as np
import time
from ex4 import dft, fft_radix2

def main():
    num_ciclos = 8
    num_amostras_por_ciclo = 2048
    freq_fundamental = 50
    freq_amostragem = num_amostras_por_ciclo * freq_fundamental

    tempo_entre_amostras = 1 / freq_amostragem
    num_amostras_total = num_ciclos * num_amostras_por_ciclo

    vet_amostras = np.arange(num_amostras_total)
    vet_tempo_discreto = vet_amostras * tempo_entre_amostras
    N = len(vet_amostras)

    sinal = 1 * np.sin(2 * np.pi * freq_fundamental * vet_tempo_discreto)

    print("Executando FFT 30 vezes: ")
    FFT_times = []
    for i in range(30):
        start_time = time.time()
        X = fft_radix2(sinal)
        stop_time = time.time()
        exec_time = stop_time - start_time
        print(f"{i+1}. Tempo de execução da FFT: {exec_time}")
        FFT_times.append(exec_time)

    with open("fft_times.txt", "w", encoding='utf-8') as arq_fft_tempos:
        for t in FFT_times:
            arq_fft_tempos.write(str(t).replace('.', ',') + '\n')

    print("Executando DFT 30 vezes: ")
    DFT_times = []
    for i in range(30):
        start_time = time.time()
        X = dft(sinal)
        stop_time = time.time()
        exec_time = stop_time - start_time
        print(f"{i+1}. Tempo de execução da DFT: {exec_time}")
        DFT_times.append(exec_time)

    with open("dft_times.txt", "w", encoding='utf-8') as arq_dft_tempos:
        for t in DFT_times:
            arq_dft_tempos.write(str(t).replace('.', ',') + '\n')
        

if __name__ == '__main__':
    main()