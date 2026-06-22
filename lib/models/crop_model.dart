class CropModel {
  final String name;
  final double score;
  final String image;

  // optional but useful for realistic UI
  final String duration;
  final String waterNeed;
  final String soilPreference;
  final String marketDemand;

  const CropModel({
    required this.name,
    required this.score,
    required this.image,
    this.duration = "90–120 days",
    this.waterNeed = "Moderate",
    this.soilPreference = "Loamy / Alluvial",
    this.marketDemand = "Stable",
  });

  /// Safe factory for API / Firebase / Map data
  factory CropModel.fromMap(Map<String, dynamic> map) {
    return CropModel(
      name: map["name"] ?? "",
      score: (map["score"] ?? 0).toDouble(),
      image: map["image"] ?? _defaultImage(),
      duration: map["duration"] ?? "90–120 days",
      waterNeed: map["waterNeed"] ?? "Moderate",
      soilPreference: map["soilPreference"] ?? "Loamy",
      marketDemand: map["marketDemand"] ?? "Stable",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "score": score,
      "image": image,
      "duration": duration,
      "waterNeed": waterNeed,
      "soilPreference": soilPreference,
      "marketDemand": marketDemand,
    };
  }

  /// Central fallback (prevents silent broken images)
  static String _defaultImage() {
    return "assets/crops/default.png";
  }
}