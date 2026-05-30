import mediapipe as mp
from mediapipe.tasks.python import vision
import cv2
import time

cap = cv2.VideoCapture(0)

options = vision.HandLandmarkerOptions(
    base_options=mp.tasks.BaseOptions(model_asset_path='hand_landmarker.task'),
    running_mode=vision.RunningMode.VIDEO
)

with vision.HandLandmarker.create_from_options(options) as detector:

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        frame = cv2.flip(frame, 1)

        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb_frame)

        timestamp_ms = int(time.time() * 1000)

        result = detector.detect_for_video(mp_image, timestamp_ms)
    
        if result.hand_landmarks:

            h, w, _ = frame.shape

            for hand_landmarks in result.hand_landmarks:

                for landmark in hand_landmarks:
                    x = int(landmark.x * w)
                    y = int(landmark.y * h)
                    cv2.circle(frame, (x, y), 5, (0, 255, 0), -1)

                connections = vision.HandLandmarksConnections.HAND_CONNECTIONS

                for connection in connections:
                    start_idx = connection.start
                    end_idx = connection.end

                    x0 = int(hand_landmarks[start_idx].x * w)
                    y0 = int(hand_landmarks[start_idx].y * h)
                    x1 = int(hand_landmarks[end_idx].x * w)
                    y1 = int(hand_landmarks[end_idx].y * h)

                    cv2.line(frame, (x0, y0), (x1, y1), (255, 0, 0), 2)


        cv2.imshow("Hand Tracking", frame)

        if cv2.waitKey(1) == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
