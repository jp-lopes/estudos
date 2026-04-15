'''
    SEL0615 - PROCESSAMENTO DIGITAL DE SINAIS
    EXERCÍCIO 5

    Nome: João Pedro Lopes de Melo
    nUSP: 15588950
'''

import numpy as np
import cv2
from scipy.io import wavfile

def questao_1():
    # 1a) Lê imagem, cria imagens completas a partir de cada canal de cor e salva
    img = cv2.imread('ex5/imagens/imagem.jpg')
    img_azul = np.zeros_like(img)
    img_verde = np.zeros_like(img)
    img_vermelho = np.zeros_like(img)

    img_azul[:, :, 0] = img[:, :, 0] 
    img_verde[:, :, 1] = img[:, :, 1]
    img_vermelho[:, :, 2]  = img[:, :, 2]

    cv2.imwrite('ex5/imagens/azul.png', img_azul)
    cv2.imwrite('ex5/imagens/verde.png', img_verde)
    cv2.imwrite('ex5/imagens/vermelho.png', img_vermelho)

    # 1b) Cria máscaras circulares e salva
    h, w, _ = img.shape
    centro_img = (w//2, h//2)
    raio_mascara_1 = 50
    raio_mascara_2 = 25

    mascara_1 = np.zeros((h, w), dtype="uint8")
    cv2.circle(mascara_1, centro_img, raio_mascara_1, 255, -1)

    mascara_2 = np.zeros((h, w), dtype="uint8")
    cv2.circle(mascara_2, centro_img, raio_mascara_2, 255, -1)
    mascara_2 = cv2.bitwise_not(mascara_2)

    cv2.imwrite('ex5/imagens/mascara_1.png', mascara_1)
    cv2.imwrite('ex5/imagens/mascara_2.png', mascara_2)

    # 1c) Aplica máscaras em cada canal de cor, junta e salva imagem filtrada
    i = 0
    b, g, r = cv2.split(img)

    for mascara in [mascara_1, mascara_2]:
        i+=1
        mascara = mascara / 255.0
        canais_filtrados = []
        
        for canal in [b, g, r]:
            freqs = np.fft.fft2(canal)                       # obtem frequencias
            freqs = np.fft.fftshift(freqs)                   # aplica shift (baixas freqs no centro e altas freqs nas bordas)
            freqs = freqs * mascara                          # aplica mascara
            freqs = np.fft.ifftshift(freqs)                  # desfaz o shift
            canal_filtrado = np.fft.ifft2(freqs)             # desfaz fft
            canal_filtrado = np.abs(canal_filtrado)          # utiliza apenas o módulo dos numeros complexos
            canal_filtrado = np.clip(canal_filtrado, 0, 255) # garante que todos os valores estão entre 0 e 255
            canal_filtrado = np.uint8(canal_filtrado)        # casting para inteiro
            canais_filtrados.append(canal_filtrado)          # salva canal filtrado

        img_reconstruida = cv2.merge(canais_filtrados)
        cv2.imwrite(f'ex5/imagens/imagem_com_mascara_{i}.png', img_reconstruida)


def questao_2():
    fs, data = wavfile.read('ex5/audios/musica.wav')
    if len(data.shape) > 1:
        data = data[:, 0]                      #Conversao de áudio estéreo para mono

    audio_fft = np.fft.fft(data)
    modulos = np.abs(audio_fft)                # pega os modulos (amplitudes) da fft do áudio
    modulos_ordenado = np.sort(modulos)        # ordena modulos
    N = len(modulos_ordenado)

    # 2a) Compressão de 5%
    limite_5_porcento = modulos_ordenado[int(0.95*N)]                         # procura indice que corresponde a 95% do total do vetor modulos_ordenado
    audio_5_porcento = np.where(modulos >= limite_5_porcento, audio_fft, 0)   # aplica o filtro de 5%
    audio_5_porcento = np.fft.ifft(audio_5_porcento)                          # desfaz fft
    audio_5_porcento = np.real(audio_5_porcento)                              # descarta parte imaginaria
    wavfile.write('ex5/audios/audio_5_porcento.wav', fs, audio_5_porcento.astype(data.dtype))

    # 2a) Compressão de 1%
    limite_1_porcento = modulos_ordenado[int(0.99*N)]                         # procura indice que corresponde a 99% do total do vetor modulos_ordenado
    audio_1_porcento = np.where(modulos >= limite_1_porcento, audio_fft, 0)   # aplica o filtro de 1%
    audio_1_porcento = np.fft.ifft(audio_1_porcento)                          # desfaz fft
    audio_1_porcento = np.real(audio_1_porcento)                              # descarta parte imaginaria
    wavfile.write('ex5/audios/audio_1_porcento.wav', fs, audio_1_porcento.astype(data.dtype))


def main():
    print("Executando questão 1")
    questao_1()
    print("Executando questão 2")
    questao_2()


if __name__ == '__main__':
    main()