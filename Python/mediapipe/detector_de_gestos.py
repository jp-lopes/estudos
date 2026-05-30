'''
Detector de gestos com mediapipe
'''


import mediapipe as mp
from mediapipe.tasks.python import vision
import cv2
import time
import numpy as np
from math import acos, degrees


def get_palm_centroid(coordinates_list):
    coordinates = np.array(coordinates_list)
    centroid = np.mean(coordinates, axis=0)
    centroid = int(centroid[0]), int(centroid[1])
    return centroid


def draw_hand_landmarks(hand_landmarks, frame, landmarks_color=(0, 255, 0), connections_color=(255, 0, 0)):
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


cap = cv2.VideoCapture(0)

options = vision.HandLandmarkerOptions(
    base_options=mp.tasks.BaseOptions(model_asset_path='hand_landmarker.task'),
    running_mode=vision.RunningMode.VIDEO
)

# Polegar
thumb_points = [1, 2, 4]
# Indicador, medio, anular e mindinho
palm_points = [0, 1, 2, 5, 9, 13, 17]
fingertips_points = [8, 12, 16, 20]
finger_base_points = [6, 10, 14, 18]

with vision.HandLandmarker.create_from_options(options) as detector:

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        h, w, _ = frame.shape
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb_frame)
        timestamp_ms = int(time.time() * 1000)
        result = detector.detect_for_video(mp_image, timestamp_ms)

        if result.hand_landmarks:
            
            coordinates_thumb = []
            coordinates_palm = []
            coordinates_ft = []
            coordinates_fb = []

            # Detecta se é mão esquerda ou direita
            handedness = result.handedness[0][0].category_name

            for hand_landmarks in result.hand_landmarks:
                # Armazenar coordenadas dos principais pontos da mão
                for index in thumb_points:
                    x = int(hand_landmarks[index].x * w)
                    y = int(hand_landmarks[index].y * h)
                    coordinates_thumb.append([x,y])

                for index in palm_points:
                    x = int(hand_landmarks[index].x * w)
                    y = int(hand_landmarks[index].y * h)
                    coordinates_palm.append([x,y])

                for index in fingertips_points:
                    x = int(hand_landmarks[index].x * w)
                    y = int(hand_landmarks[index].y * h)
                    coordinates_ft.append([x,y])

                for index in finger_base_points:
                    x = int(hand_landmarks[index].x * w)
                    y = int(hand_landmarks[index].y * h)
                    coordinates_fb.append([x,y])

                nx, ny = get_palm_centroid(coordinates_palm)

                # Polegar
                p1 = np.array(coordinates_thumb[0])
                p2 = np.array(coordinates_thumb[1])
                p3 = np.array(coordinates_thumb[2])
                
                l1 = np.linalg.norm(p2 - p3)
                l2 = np.linalg.norm(p1 - p3)
                l3 = np.linalg.norm(p1 - p2)

                if l1 != 0 and l3 != 0:
                    cos_angle = (l1**2 + l3**2 - l2**2) / (2*l1*l3)
                    cos_angle = np.clip(cos_angle, -1.0, 1.0)
                    angle = degrees(acos(cos_angle))
                else:
                    angle = 0
                
                thumb_finger = np.array(False)
                if angle > 150:
                    thumb_finger = np.array(True)

                # Indicador, medio, anular e mindinho
                
                cv2.circle(frame, (nx, ny), 5, (0, 255, 0), -1)
                coordinates_centroid = np.array([nx, ny])
                coordinates_ft = np.array(coordinates_ft)
                coordinates_fb = np.array(coordinates_fb)

                d_centroid_ft = np.linalg.norm(coordinates_centroid - coordinates_ft, axis=1)
                d_centroid_fb = np.linalg.norm(coordinates_centroid - coordinates_fb, axis=1)

                dif = d_centroid_ft - d_centroid_fb
                
                fingers = dif > 0
                fingers = np.append(thumb_finger, fingers)

                
                fingers_counter = str(np.count_nonzero(fingers==True))
                
                thumb_extended = fingers[0]
                index_extended = fingers[1]
                middle_extended = fingers[2]
                ring_extended = fingers[3]
                pinky_extended = fingers[4] 

                # Coracao
                #p3 = np.array([int(hand_landmarks[3].x * w), int(hand_landmarks[3].y * h)])
                #p7 = np.array([int(hand_landmarks[7].x * w), int(hand_landmarks[7].y * h)])
                #d_fds = np.linalg.norm(p3 - p7)
                #print(d_fds)
               
                # Ok
                coordinates_thumb_ft = np.array([int(hand_landmarks[4].x * w), int(hand_landmarks[4].y * h)])
                coordinates_index_ft = np.array([int(hand_landmarks[8].x * w), int(hand_landmarks[8].y * h)])
                d_thummbft_indexft = np.linalg.norm(coordinates_thumb_ft - coordinates_index_ft)
                
                ok_detected = (d_thummbft_indexft < 40) and middle_extended and ring_extended and pinky_extended
                if ok_detected:
                    print("Ok")

                # Hi-Five
                hifive_detected = thumb_extended and index_extended and middle_extended and ring_extended and pinky_extended
                if hifive_detected:
                    print("Hi-Five")

                # Hang-Loose
                hangloose_detected = thumb_extended and not index_extended and not middle_extended and not ring_extended and pinky_extended
                if hangloose_detected:
                    print("Hang-Loose")

                # Peace
                peace_detected = not thumb_extended and index_extended and middle_extended and not ring_extended and not pinky_extended
                if peace_detected:
                    print("Peace")

                # Rock
                rock_detected = thumb_extended and index_extended and not middle_extended and not ring_extended and pinky_extended
                if rock_detected:
                    print("Rock")

                # Middle finger
                middle_finger_detected = thumb_extended and not index_extended and middle_extended and not ring_extended and not pinky_extended
                if middle_finger_detected:
                    print("Middle finger")

                # Thumbs Up
                coordinates_thumb_fb = np.array([int(hand_landmarks[2].x * w), int(hand_landmarks[2].y * h)])
                up_vector = np.array([0,-1])

                thumb_vector = coordinates_thumb_ft - coordinates_thumb_fb 
                thumb_vector = thumb_vector / np.linalg.norm(thumb_vector)

                alignment = np.dot(thumb_vector, up_vector)

                thumbsUp_detected = alignment > 0.7 and thumb_extended and not index_extended and not middle_extended and not ring_extended and not pinky_extended
                if thumbsUp_detected:
                    print("Thumbs Up")

                # Thumbs Down
                thumbsDows_detected = alignment < -0.7 and thumb_extended and not index_extended and not middle_extended and not ring_extended and not pinky_extended
                if thumbsDows_detected:
                    print("Thumbs Down")

                draw_hand_landmarks(hand_landmarks, frame)

        frame = cv2.flip(frame, 1)
        cv2.imshow("Hand Tracking", frame)

        if cv2.waitKey(1) == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
