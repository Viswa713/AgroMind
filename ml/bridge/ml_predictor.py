import os
import sys
import json
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing import image

# =========================
# PATH SETUP (Render-safe)
# =========================
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

MODEL_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "models",
    "tomato_model.keras"
)

IMG_SIZE = (224, 224)

# Must match training labels EXACTLY
class_names = [
    "early_blight",
    "healthy",
    "late_blight",
    "mosaic_virus",
    "septoria_leaf_spot"
]

# =========================
# GLOBAL MODEL (lazy load)
# =========================
model = None


def load_model_once():
    global model

    if model is None:
        if not os.path.exists(MODEL_PATH):
            raise RuntimeError(f"Model not found: {MODEL_PATH}")

        model = tf.keras.models.load_model(MODEL_PATH, compile=False)

    return model


# =========================
# PREDICTION FUNCTION
# =========================
def predict_image(img_path):
    model = load_model_once()

    if not os.path.exists(img_path):
        raise RuntimeError(f"Image not found: {img_path}")

    try:
        img = image.load_img(img_path, target_size=IMG_SIZE)
    except Exception as e:
        raise RuntimeError(f"Image load failed: {str(e)}")

    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = img_array / 255.0

    preds = model.predict(img_array, verbose=0)[0]

    index = int(np.argmax(preds))
    confidence = float(np.max(preds))

    return {
        "disease": class_names[index],
        "confidence": round(confidence * 100, 2)
    }


# =========================
# CLI MODE (local testing)
# =========================
if __name__ == "__main__":
    try:
        if len(sys.argv) < 2:
            raise Exception("No image path provided")

        result = predict_image(sys.argv[1])

        print(json.dumps(result))

    except Exception as e:
        print(json.dumps({
            "disease": "error",
            "confidence": 0,
            "error": str(e)
        }))
        sys.exit(1)