'''
Speech to text em Python com Vosk e PyAudio
Tutorial: https://youtu.be/3Mga7_8bYpw?si=wygImEoJXpREPNOG
'''

from vosk import Model, KaldiRecognizer
import pyaudio

try:
    model = Model("/home/jplop/Documents/models/vosk-model-small-pt-0.3")
    recognizer = KaldiRecognizer(model, 16000)
    mic = pyaudio.PyAudio()
    stream = mic.open(format=pyaudio.paInt16, channels=1, rate=16000, input=True, frames_per_buffer=8192)
except Exception as e: 
    print(f'Erro: {e}')
    exit(-1)

try:
    stream.start_stream()
    while True:
        data = stream.read(4096)
        if recognizer.AcceptWaveform(data):
            text = recognizer.Result()
            print(text)

except Exception as e:
    print(f"Erro: {e}")

finally:
    if stream.is_active():
        print("Fechando stream")
        stream.stop_stream()
        print("Fechando microfone")
        mic.close(stream)