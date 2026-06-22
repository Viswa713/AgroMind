# ml/recommendation/pesticide_engine.py

def get_treatment(disease_name):
    treatments = {
        "early_blight": {
            "pesticide": "Chlorothalonil",
            "action": "Remove infected leaves and spray fungicide weekly"
        },
        "late_blight": {
            "pesticide": "Mancozeb / Metalaxyl",
            "action": "Improve drainage and apply fungicide immediately"
        },
        " mosaic_virus": {
            "pesticide": "Insect control (no direct cure)",
            "action": "Remove infected plants and control aphids"
        },
        "septoria_leaf_spot": {
            "pesticide": "Copper-based fungicide",
            "action": "Avoid wet leaves and spray copper fungicide"
        },
        "healthy": {
            "pesticide": "None",
            "action": "Plant is healthy"
        }
    }

    return treatments.get(disease_name, {
        "pesticide": "Unknown",
        "action": "No recommendation available"
    })