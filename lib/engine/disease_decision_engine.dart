class DiseaseDecisionEngine {
  static Map<String, dynamic> getRecommendation(String disease) {
    switch (disease.toLowerCase()) {

      case "early_blight":
        return {
          "pesticide": "Chlorothalonil / Mancozeb",
          "treatment": [
            "Remove infected leaves immediately",
            "Avoid overhead irrigation",
            "Spray fungicide every 7–10 days"
          ]
        };

      case "late_blight":
        return {
          "pesticide": "Copper-based fungicide / Mancozeb",
          "treatment": [
            "Destroy infected plants quickly",
            "Improve air circulation",
            "Apply fungicide before rain"
          ]
        };

      case " mosaic_virus":
        return {
          "pesticide": "No chemical cure",
          "treatment": [
            "Remove infected plants",
            "Control aphids (vector)",
            "Use resistant varieties"
          ]
        };

      case "septoria_leaf_spot":
        return {
          "pesticide": "Copper fungicide / Chlorothalonil",
          "treatment": [
            "Remove lower infected leaves",
            "Avoid wet foliage",
            "Spray weekly if severe"
          ]
        };

      case "healthy":
        return {
          "pesticide": "None required",
          "treatment": [
            "Plant is healthy",
            "Maintain current care routine"
          ]
        };

      default:
        return {
          "pesticide": "Unknown",
          "treatment": [
            "Consult agricultural expert",
            "Re-scan image with better lighting"
          ]
        };
    }
  }
}