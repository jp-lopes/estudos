import numpy as np
import matplotlib.pyplot as plt

def fft_radix2(x):
    N = len(x)
    k = np.arange(N//2)
    W = np.exp(-1j * 2 * np.pi * k / N)
    return fft_rec(x,W)


def fft_rec(x, W):
    N = len(x)
    if N == 1:
        return x

    x_par = x[0::2]
    x_impar = x[1::2]

    W_sub = W[0::2]

    X_par = fft_rec(x_par, W_sub)
    X_impar = fft_rec(x_impar, W_sub)

    X = [0j] * N

    X[0:N//2] = X_par + W[0:N//2] * X_impar 
    X[N//2:N] = X_par - W[0:N//2] * X_impar
    
    return X


def dft(x):
    N = len(x)
    X = [0j] * N

    for m in range(N):
        soma = 0 + 0j

        for n in range(N):
            soma += x[n] * (np.cos(2 * np.pi * n * m / N) - 1j * np.sin(2 * np.pi * n * m / N))

        X[m] = soma
    
    return X


plot_idx = 0
def plot(x, y, titulo, x_label, y_label, stem=False, xlim=0):
    global plot_idx
    plt.figure(plot_idx, figsize=(10, 6))
    plot_idx += 1
    if stem: plt.stem(x, y)
    else: plt.plot(x, y, 'r')
    plt.title(titulo)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.grid(True)
    if xlim > 0:
        plt.xlim(0, xlim)


def main():
    num_ciclos = 8
    num_amostras_por_ciclo = 2048
    freq_fundamental = 50
    freq_amostragem = num_amostras_por_ciclo * freq_fundamental

    tempo_entre_amostras = 1 /  freq_amostragem
    num_amostras_total = num_ciclos * num_amostras_por_ciclo

    vet_amostras = np.arange(num_amostras_total)
    vet_tempo_discreto = vet_amostras * tempo_entre_amostras
    N = len(vet_amostras)

    sinal = 1 * np.sin(2 * np.pi * freq_fundamental * vet_tempo_discreto)

    plot(vet_tempo_discreto, sinal, "Sinal Original (50Hz)", "Tempo (s)", "Amplitude")

    X = fft_radix2(sinal)

    magnitudes = []
    frequencias = []
    
    print("Frequências encontradas na FFT: ")
    for m in range(N//2):
        freq = m * freq_amostragem / N
        if m == 0: amp = (np.abs(X[m]) / N)
        else: amp = ((2 * np.abs(X[m])) / N)
        magnitudes.append(amp)
        frequencias.append(freq)
        if amp > 0.1:
            print(f"Frequência: {freq:.2f}Hz, Amplitude: {amp:.2f}")

    plot(frequencias, magnitudes, "Espectro de Frequências FFT", "Frequência (Hz)", "Amplitude", stem=True, xlim=500)

    

if __name__ == '__main__':
    main()
    plt.show() # exibe os gráficos