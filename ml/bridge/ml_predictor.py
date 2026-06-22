import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing import image
import os
import sys
import json

# =========================
# PATH SETUP
# =========================

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

MODEL_PATH = os.path.abspath(
    os.path.join(
        BASE_DIR,
        "..",
        "models",
        "tomato_model.keras"
    )
)

IMG_SIZE = (224, 224)

# IMPORTANT:
# MUST MATCH TRAINING ORDER EXACTLY
class_names = [
    "early_blight",
    "healthy",
    "late_blight",
    "mosaic_virus",
    "septoria_leaf_spot"
]

# =========================
# MODEL LOADING
# =========================

if not os.path.exists(MODEL_PATH):
    raise FileNotFoundError(
        f"Model not found: {MODEL_PATH}"
    )

model = None

def load_model_once():
    global model

    if model is None:
        model = tf.keras.models.load_model(MODEL_PATH)

    return model

# =========================
# PREDICTION
# =========================

def predict_image(img_path):
    model = load_model_once()

    img = image.load_img(
        img_path,
        target_size=IMG_SIZE
    )

    img_array = image.img_to_array(img)

    img_array = np.expand_dims(
        img_array,
        axis=0
    )

    img_array = img_array / 255.0

    preds = model.predict(
        img_array,
        verbose=0
    )[0]

    index = int(np.argmax(preds))

    confidence = float(
        np.max(preds)
    )

    return {
        "disease": class_names[index],
        "confidence": round(confidence * 100, 2)
    }

# =========================
# CLI MODE
# =========================

if __name__ == "__main__":
    try:

        if len(sys.argv) < 2:
            raise Exception(
                "No image path provided"
            )

        img_path = sys.argv[1]

        result = predict_image(img_path)

        print(
            json.dumps(result)
        )

    except Exception as e:

        print(
            json.dumps({
                "disease": "error",
                "confidence": 0,
                "error": str(e)
            })
        )

        sys.exit(1)