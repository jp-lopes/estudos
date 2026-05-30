'''
Desenhar na tela usando apenas o dedo indicador
'''

import mediapipe as mp
from mediapipe.tasks.python import vision
import cv2
import time
import numpy as np
from math import acos, degrees

def draw_hand_landmarks(hand_landmarks, frame, landmarks_color=(0, 255, 0), connections_color=(255, 0, 0)):
    h, w, _ = frame.shape
    for landmark in hand_landmarks:
        x = int(landmark.x * w)
        y = int(landmark.y * h)
        cv2.circle(frame, (x, y), 5, landmarks_color, -1)

    for connection in vision.HandLandmarksConnections.HAND_CONNECTIONS:
        start_idx = connection.start
        end_idx = connection.end

        x0 = int(hand_landmarks[start_idx].x * w)
        y0 = int(hand_landmarks[start_idx].y * h)
        x1 = int(hand_landmarks[end_idx].x * w)
        y1 = int(hand_landmarks[end_idx].y * h)
        
        cv2.line(frame, (x0, y0), (x1, y1), connections_color, 2)

def draw_points(frame, points_array):
    for p in points_array:
        cv2.circle(frame, (p[0], p[1]), 5, (0,0,255), -1)


def main():
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("Error while opening the camera.")
        return

    options = vision.HandLandmarkerOptions(
        base_options=mp.tasks.BaseOptions(model_asset_path='hand_landmarker.task'),
        running_mode=vision.RunningMode.VIDEO,
        num_hands = 1
    )

    up_vector = np.array([0,-1])

    # Conjunto de pontos que serao desenhados
    points_to_be_drawn = []

    with vision.HandLandmarker.create_from_options(options) as detector:

        while True:
            ret, frame = cap.read()
            if not ret:
                break

            h, w, _ = frame.shape
            rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb_frame)
            timestamp_ms = int(time.monotonic() * 1000)
            result = detector.detect_for_video(mp_image, timestamp_ms)

            if result.hand_landmarks:
                hand_landmarks = result.hand_landmarks[0]

                # Armazena coordenadas de todos os pontos da mao
                hand_points = []
                for i in range(21):
                    x = int(hand_landmarks[i].x * w)
                    y = int(hand_landmarks[i].y * h)
                    hand_points.append([x,y])

                # Detecta se é mão esquerda ou direita
                is_right_hand = result.handedness[0][0].category_name == 'Right'
                
                # Verifica se a palma da mao esta virada para a camera
                p5_x =  hand_points[5][0]
                p17_x = hand_points[17][0]

                is_palm_facing_camera = not ((p5_x - p17_x > 0) ^ is_right_hand)
                if is_palm_facing_camera:

                    # Desenha pontos e ligações
                    draw_hand_landmarks(hand_landmarks,frame)

                    # Verifica se o polegar esta extendido
                    p1 = np.array(hand_points[1])
                    p2 = np.array(hand_points[2])
                    p4 = np.array(hand_points[4])
                    
                    l1 = np.linalg.norm(p2 - p4)
                    l2 = np.linalg.norm(p1 - p4)
                    l3 = np.linalg.norm(p1 - p2)

                    if l1 != 0 and l3 != 0:
                        cos_angle = (l1**2 + l3**2 - l2**2) / (2*l1*l3)
                        cos_angle = np.clip(cos_angle, -1.0, 1.0)
                        angle = degrees(acos(cos_angle))
                    else:
                        angle = 0
                    
                    is_thumb_extended = angle > 150

                    # Verifica se os dedos indicador, medio, anular e mindinho estao extendidos
                    fingertips_coordinates = [hand_points[8], hand_points[12], hand_points[16], hand_points[20]]
                    fingertips_coordinates = np.array(fingertips_coordinates)

                    fingerbases_coordinates = [hand_points[6], hand_points[10], hand_points[14], hand_points[18]]
                    fingerbases_coordinates = np.array(fingerbases_coordinates)

                    p0 = np.array(hand_points[0])

                    distance_fingertips_to_p0 = np.linalg.norm(p0 - fingertips_coordinates, axis=1)
                    distance_fingerbases_to_p0 = np.linalg.norm(p0 - fingerbases_coordinates, axis=1)
                    
                    fingers_extended = distance_fingertips_to_p0 - distance_fingerbases_to_p0 > 0
                    
                    is_index_extended = fingers_extended[0]
                    is_middle_extended = fingers_extended[1]
                    is_ring_extended = fingers_extended[2]
                    is_pinky_extended = fingers_extended[3]

                    # Verifica direcao do dedo indicador (cima)
                    p6 = np.array(hand_points[6])
                    p8 = np.array(hand_points[8])

                    index_vector = p8 - p6
                    index_vector_norm = np.linalg.norm(index_vector)
                    if index_vector_norm != 0:
                        index_vector = index_vector / index_vector_norm
                    else:
                        index_vector = np.array([0,0])

                    index_vertical_alignment = np.dot(index_vector, up_vector)
                    is_index_up = index_vertical_alignment > 0.7

                    # Verifica direcao do dedo mindinho (cima)
                    p18 = np.array(hand_points[18])
                    p20 = np.array(hand_points[20])

                    pinky_vector = p20 - p18
                    pinky_vector_norm = np.linalg.norm(pinky_vector)
                    if pinky_vector_norm != 0:
                        pinky_vector = pinky_vector / pinky_vector_norm
                    else:
                        pinky_vector = np.array([0,0])

                    pinky_vertical_alignment = np.dot(pinky_vector, up_vector)
                    is_pinky_up = pinky_vertical_alignment > 0.7

                    
                    # ------- DETECÇÃO DE GESTOS -------
                    current_hand_gesture = None

                    # Index Up                
                    if not is_thumb_extended and is_index_up and is_index_extended and not is_middle_extended and not is_ring_extended and not is_pinky_extended:
                        current_hand_gesture = "Index Up"
                    # Pinky Up
                    elif not is_thumb_extended and is_pinky_up and not is_index_extended and not is_middle_extended and not is_ring_extended and is_pinky_extended:
                        current_hand_gesture = "Pinky Up"

                    # Desenhar a partir da ponta do dedo indicador
                    if current_hand_gesture == "Index Up":
                        points_to_be_drawn.append((p8[0],p8[1]))

                    # Apagar desenho inteiro com o dedo mindinho
                    elif current_hand_gesture == "Pinky Up":
                        points_to_be_drawn.clear()

            draw_points(frame,points_to_be_drawn)

            frame = cv2.flip(frame,1)
            cv2.imshow("Hand Gestures Detection", frame)

            if cv2.waitKey(1) == ord('q'):
                break

    cap.release()
    cv2.destroyAllWindows()


if __name__ == '__main__':
    main()