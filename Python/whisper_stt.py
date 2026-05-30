#!/usr/bin/env python3


'''
Speech to Text com Faster Whisper.
Ideia principal: ao invés de usar o som ao vivo, são gravados trechos de áudio. 
O Whisper consegue trabalhar muito melhor com áudios curtos do que com som ao vivo.

Código adaptado de: 
https://youtu.be/AyF2ioX_JgU?si=u35r0K8pUQESoqvD   
https://github.com/OminousIndustries/Bob/tree/main

'''

import time
import subprocess
import wave
import numpy as np
from pathlib import Path
from faster_whisper import WhisperModel


# Preferred capture settings (we’ll auto-fallback if device refuses)
PREF_SAMPLE_RATE = 16000
PREF_CHANNELS = 1

# VAD settings
FRAME_MS = 30
SILENCE_THRESHOLD = 120   # Base RMS
END_SILENCE_MS = 800
MIN_SPEECH_MS = 300
MAX_RECORDING_MS = 15000

# Models
WHISPER_MODEL = "small"

# Conversation
AUTO_RESTART_DELAY = 1.5

# Temp file
TEMP_WAV = Path("/tmp/recording.wav")


# ===== Init =====
def init_models():
    print("Starting Voice Chatbot...")
    print("Loading models (this may take a moment the first time)...")

    print("Loading Whisper...")
    whisper = WhisperModel(
        WHISPER_MODEL,
        device="cpu",
        compute_type="int8",
        cpu_threads=4,
        download_root=str(Path.home() / ".cache" / "whisper")
    )

    print("All models loaded successfully!\n")
    return whisper


def _spawn_pw_cat_record(rate, channels):
    cmd = [
        "pw-cat", "--record", "-",
        "--format", "s16",
        "--rate", str(rate),
        "--channels", str(channels)
    ]
    return subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def _select_record_pipeline():
    """
    Try a few (rate,channels) combos so we don't crash if the device
    refuses 16k mono. Returns (proc, rate, channels, first_chunk or None, err_text).
    """
    attempts = [
        (PREF_SAMPLE_RATE, PREF_CHANNELS),  # 16k / mono
        (PREF_SAMPLE_RATE, 2),              # 16k / stereo
        (48000, PREF_CHANNELS),             # 48k / mono
        (48000, 2),                         # 48k / stereo
    ]
    for rate, ch in attempts:
        proc = _spawn_pw_cat_record(rate, ch)
        bytes_per_sample = 2
        frame_bytes = int(rate * FRAME_MS / 1000) * bytes_per_sample * ch
        chunk = proc.stdout.read(frame_bytes)
        if chunk:
            return proc, rate, ch, chunk, ""
        err = (proc.stderr.read() or b"").decode("utf-8", errors="ignore")
        try:
            proc.terminate(); proc.wait(timeout=0.5)
        except Exception:
            try:
                proc.kill()
            except Exception:
                pass
        if err.strip():
            print(f"   ⚠️  pw-cat refused {rate}Hz/{ch}ch: {err.strip()}")
        else:
            print(f"   ⚠️  pw-cat produced no data at {rate}Hz/{ch}ch, retrying...")
    return None, None, None, None, "No working pw-cat configuration found"


def record_with_vad(timeout_seconds=30):
    """Record audio until silence is detected (VAD). Returns (bytes, rate, channels) or (None, None, None)."""
    print("Listening... (speak now)")

    proc, rate, ch, first_chunk, err = _select_record_pipeline()
    if not proc:
        print(f"❌ {err}")
        return None, None, None

    bytes_per_sample = 2
    frame_bytes = int(rate * FRAME_MS / 1000) * bytes_per_sample * ch
    audio_buffer = bytearray()

    try:
        # Quick calibration (~300ms)
        noise_samples = []
        if first_chunk:
            s = np.frombuffer(first_chunk, dtype=np.int16).astype(np.float32)
            noise_samples.append(float(np.sqrt(np.mean(s * s))))
        for _ in range(9):
            chunk = proc.stdout.read(frame_bytes)
            if chunk:
                s = np.frombuffer(chunk, dtype=np.int16).astype(np.float32)
                noise_samples.append(float(np.sqrt(np.mean(s * s))))
        noise_floor = float(np.median(noise_samples)) if noise_samples else 50.0
        threshold = max(SILENCE_THRESHOLD, noise_floor * 1.8)
        #print(f"   📏 Noise floor: {noise_floor:.1f}  |  Threshold: {threshold:.1f}")

        is_speaking = False
        silence_ms = 0
        speech_ms = 0
        total_ms = 0
        start = time.time()

        if first_chunk is not None:
            samples = np.frombuffer(first_chunk, dtype=np.int16).astype(np.float32)
            rms = float(np.sqrt(np.mean(samples * samples)))
            level = int(rms / 100)
            #print(f"\r  Level: {'▁'*min(level,20):<20} ", end="", flush=True)
            if rms > threshold:
                is_speaking = True
                speech_ms = FRAME_MS
                audio_buffer.extend(first_chunk)

        while True:
            if (time.time() - start) > timeout_seconds:
                if not is_speaking:
                    return None, None, None
                break

            chunk = proc.stdout.read(frame_bytes)
            if not chunk:
                err = (proc.stderr.read() or b"").decode("utf-8", errors="ignore").strip()
                if err:
                    print(f"\n❗ pw-cat: {err}")
                break

            samples = np.frombuffer(chunk, dtype=np.int16).astype(np.float32)
            rms = float(np.sqrt(np.mean(samples * samples)))
            level = int(rms / 100)
            #print(f"\r  Level: {'▁'*min(level,20):<20} ", end="", flush=True)

            if is_speaking:
                audio_buffer.extend(chunk)
                if rms < threshold:
                    silence_ms += FRAME_MS
                else:
                    silence_ms = 0
                    speech_ms += FRAME_MS

                if silence_ms >= END_SILENCE_MS and speech_ms >= MIN_SPEECH_MS:
                    dur_s = len(audio_buffer) / (rate * bytes_per_sample * ch)
                    #print(f"\n  ✓ Recorded {dur_s:.1f}s")
                    break
                elif total_ms >= MAX_RECORDING_MS:
                    #print("\n  ✓ Max recording length")
                    break
            else:
                if rms > threshold:
                    is_speaking = True
                    speech_ms = FRAME_MS
                    silence_ms = 0
                    audio_buffer.extend(chunk)
                    #print("\n  💬 Speech detected!")

            total_ms += FRAME_MS

    except KeyboardInterrupt:
        #print("\n  ⏹️  Recording stopped")
        audio_buffer = None
    finally:
        try:
            proc.terminate(); proc.wait(timeout=0.8)
        except Exception:
            try:
                proc.kill()
            except Exception:
                pass

    if audio_buffer and len(audio_buffer) > 1000:
        return bytes(audio_buffer), rate, ch
    return None, None, None


def save_wav(audio_data, filepath, sample_rate, channels):
    with wave.open(str(filepath), 'wb') as wf:
        wf.setnchannels(channels)
        wf.setsampwidth(2)  # 16-bit
        wf.setframerate(sample_rate)
        wf.writeframes(audio_data)


def transcribe_audio(whisper_model, audio_path):
    print("Transcribing...")
    try:
        segments, info = whisper_model.transcribe(
            str(audio_path),
            language="pt",
            beam_size=1,
            best_of=1,
            temperature=0.0,
            vad_filter=True,
            vad_parameters=dict(
                min_silence_duration_ms=500,
                speech_pad_ms=200
            )
        )
        text = " ".join(seg.text.strip() for seg in segments)
        return text.strip() if text else None
    except Exception as e:
        print(f"❌ Transcription error: {e}")
        return None


def record_fixed_seconds(seconds=3):
    print(f"Recording ~{seconds}s for test...")

    proc, rate, ch, first_chunk, err = _select_record_pipeline()
    if not proc:
        print(f"❌ {err}")
        return None, None, None

    bytes_per_sample = 2
    frame_bytes = int(rate * FRAME_MS / 1000) * bytes_per_sample * ch
    total_frames = int((seconds * 1000) / FRAME_MS)
    buf = bytearray()
    if first_chunk:
        buf.extend(first_chunk)

    try:
        for _ in range(total_frames - (1 if first_chunk else 0)):
            chunk = proc.stdout.read(frame_bytes)
            if not chunk:
                err = (proc.stderr.read() or b"").decode("utf-8", errors="ignore").strip()
                if err:
                    print(f"❗ pw-cat: {err}")
                break
            buf.extend(chunk)
    finally:
        try:
            proc.terminate(); proc.wait(timeout=0.8)
        except Exception:
            try:
                proc.kill()
            except Exception:
                pass

    return (bytes(buf), rate, ch) if buf else (None, None, None)

# ===== Main =====
def main():
    whisper_model = init_models()

    print("VOICE TRANSCRIPTION READY!")
    print("="*50)
    print("Press Ctrl+C to stop.\n")

    while True:
        try:
            audio_data, rate, ch = record_with_vad(timeout_seconds=30)

            if audio_data:
                save_wav(audio_data, TEMP_WAV, sample_rate=rate, channels=ch)
                user_text = transcribe_audio(whisper_model, TEMP_WAV)

                if user_text:
                    print(f"\nYou said: \"{user_text}\"\n")
                    if any(w in user_text.lower() for w in ["adeus"]):
                        break

                    #print(f"Ready again in {AUTO_RESTART_DELAY}s...")
                    time.sleep(AUTO_RESTART_DELAY)
                    #print("Listening...\n")
                else:
                    print("No speech detected in the captured audio\n")
            else:
                print("No speech detected, still listening...\n")
                time.sleep(0.5)

        except KeyboardInterrupt:
            print("\n\nInterrupted by user")
            break
        except Exception as e:
            print(f"\n❌ Error: {e}")
            print("Restarting in 3 seconds...\n")
            time.sleep(3)

    print("="*50)

if __name__ == "__main__":
    main()