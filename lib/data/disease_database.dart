class DiseaseDatabase {
  /// disease → possible crops mapping
  static const Map<String, List<String>> diseaseToCrops = {
    // 🌾 Cereals
    "leaf blight": ["Rice", "Wheat", "Maize"],
    "bacterial blight": ["Rice", "Cotton"],
    "rust": ["Wheat", "Maize"],
    "smut": ["Maize"],

    // 🍅 Vegetables
    "early blight": ["Tomato", "Potato"],
    "late blight": ["Tomato", "Potato"],
    "leaf curl": ["Chilli", "Tomato"],

    // 🌱 Pulses
    "wilt": ["Chickpea", "Pigeon Pea", "Cotton"],
    "root rot": ["Groundnut", "Soybean"],

    // 🌿 Plantation crops
    "black sigatoka": ["Banana"],
    "bud rot": ["Coconut"],

    // 🌾 Fiber crops
    "boll rot": ["Cotton"],

    // fallback (unknown disease)
    "unknown": [],
  };

  /// safe lookup (always returns list)
  static List<String> getCropsForDisease(String disease) {
    final key = disease.toLowerCase().trim();

    // direct match
    if (diseaseToCrops.containsKey(key)) {
      return diseaseToCrops[key]!;
    }

    // partial match fallback
    for (final entry in diseaseToCrops.entries) {
      if (key.contains(entry.key) || entry.key.contains(key)) {
        return entry.value;
      }
    }

    return [];
  }
}