import '../models/farm_cluster_model.dart';

class IrrigationResult {
  final bool needsWater;
  final String urgency;
  final int recommendedMinutes;
  final int waterScore; // 0–100 (IMPORTANT for priority engine)

  IrrigationResult({
    required this.needsWater,
    required this.urgency,
    required this.recommendedMinutes,
    required this.waterScore,
  });
}

class IrrigationEngine {
  IrrigationResult evaluate(FarmCluster zone) {
    final health = zone.health;
    final stage = zone.stage;

    // =========================
    // BASE WATER STRESS FROM HEALTH
    // =========================
    int score;
    String urgency;
    int minutes;

    if (health < 0.2) {
      score = 90;
      urgency = "CRITICAL";
      minutes = 30;
    } else if (health < 0.4) {
      score = 70;
      urgency = "HIGH";
      minutes = 20;
    } else if (health < 0.7) {
      score = 40;
      urgency = "MEDIUM";
      minutes = 10;
    } else {
      score = 10;
      urgency = "LOW";
      minutes = 5;
    }

    // =========================
    // STAGE MODIFIERS (REFINEMENT ONLY)
    // =========================
    switch (stage) {
      case "seed":
        score += 10;
        minutes += 5;
        break;
      case "sprout":
        score += 5;
        minutes += 3;
        break;
      case "growing":
        score += 2;
        minutes += 1;
        break;
      case "mature":
        score -= 10;
        minutes -= 2;
        break;
    }

    // =========================
    // SAFETY CLAMPS
    // =========================
    if (score > 100) score = 100;
    if (score < 0) score = 0;
    if (minutes < 5) minutes = 5;

    final needsWater = score > 30;

    return IrrigationResult(
      needsWater: needsWater,
      urgency: urgency,
      recommendedMinutes: minutes,
      waterScore: score,
    );
  }
}