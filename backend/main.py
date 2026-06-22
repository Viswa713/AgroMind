from fastapi import FastAPI, UploadFile, File
import tempfile
import os
import sys

# =========================
# PATH FIX (project root access)
# =========================
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(BASE_DIR)

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

        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as temp:
            temp.write(await file.read())
            temp_path = temp.name

        print("TEMP FILE CREATED:", temp_path)
        print("FILE SIZE:", os.path.getsize(temp_path))

        result = predict_image(temp_path)

        print("ML RESULT:", result)

        return {
            "success": True,
            "disease": result.get("disease", "unknown"),
            "confidence": float(result.get("confidence", 0))
        }

    except Exception as e:
        print("PREDICTION ERROR:", str(e))

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
# LOCAL RUN ONLY (Render ignores this)
# =========================
if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8000))

    uvicorn.run(
        app,   # ✅ FIX: use app directly (NOT string import)
        host="0.0.0.0",
        port=port,
        reload=False
    )