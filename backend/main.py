from fastapi import FastAPI, UploadFile, File
import tempfile
import os
import sys

# =========================
# PATH FIX (Render-safe)
# =========================
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(ROOT_DIR)

from ml.bridge.ml_predictor import predict_image

app = FastAPI()


# =========================
# HEALTH CHECK
# =========================
@app.get("/")
def health():
    return {
        "status": "running",
        "service": "AgroMind ML API"
    }


# =========================
# PREDICTION ENDPOINT
# =========================
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    temp_path = None

    try:
        suffix = os.path.splitext(file.filename)[1]

        # safer temp file (Render-friendly)
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as temp:
            temp.write(await file.read())
            temp_path = temp.name

        result = predict_image(temp_path)

        return {
            "success": True,
            "disease": result["disease"],
            "confidence": float(result["confidence"])
        }

    except Exception as e:
        return {
            "success": False,
            "disease": "error",
            "confidence": 0,
            "error": str(e)
        }

    finally:
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)


# =========================
# LOCAL DEV ONLY (NOT USED IN RENDER)
# =========================
if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8000))

    uvicorn.run(
        "backend.main:app",
        host="0.0.0.0",
        port=port,
        reload=False
    )