'''
    Script de treinamento do modelo mediapipe de reconhecimento de gestos
    Guia: https://ai.google.dev/edge/mediapipe/solutions/customization/gesture_recognizer
    Dataset HaGRIDv2: https://github.com/hukenovs/hagrid/tree/master?tab=readme-ov-file
'''

import tensorflow as tf
assert tf.__version__.startswith('2')
from mediapipe_model_maker import gesture_recognizer

# Load the dataset
print("### Load the dataset ###")

dataset_path = "/media/jplop/HD_1TB/dataset_gestos/"

data = gesture_recognizer.Dataset.from_folder(
    dirname=dataset_path,
    hparams=gesture_recognizer.HandDataPreprocessingParams()
)
train_data, rest_data = data.split(0.8)
validation_data, test_data = rest_data.split(0.5)

# Train the model
print("### Train the model ###")

hparams = gesture_recognizer.HParams(
    export_dir="exported_model",
    epochs=20,           # Aumentamos de 10 para 20 para o modelo aprender detalhes finos
    batch_size=16,       # Tamanho do lote. Se seu PC travar, diminua para 8
    learning_rate=0.001, # Velocidade de aprendizado. 
    steps_per_epoch=None # Deixe em None para ele percorrer o dataset todo
)

options = gesture_recognizer.GestureRecognizerOptions(hparams=hparams)
model = gesture_recognizer.GestureRecognizer.create(
    train_data=train_data,
    validation_data=validation_data,
    options=options
)

# Evaluate the model performance
print("### Evaluate the model performance ###")

loss, acc = model.evaluate(test_data, batch_size=1)
print(f"Test loss:{loss}, Test accuracy:{acc}")

# Export to Tensorflow Lite Model
print("### Export to Tensorflow Lite Model ###")

model.export_model()