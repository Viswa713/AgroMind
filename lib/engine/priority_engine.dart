import '../models/farm_cluster_model.dart';
import 'alert_engine.dart';

enum PriorityLevel {
  low,
  medium,
  high,
  critical,
}

class PriorityResult {
  final PriorityLevel level;
  final double score;
  final List<String> reasons;
  final String primaryFactor;

  PriorityResult({
    required this.level,
    required this.score,
    required this.reasons,
    required this.primaryFactor,
  });
}

class PriorityEngine {
  final AlertEngine _alertEngine = AlertEngine();

  PriorityResult evaluate(FarmCluster cluster) {
    double score = 0;
    final List<String> reasons = [];
    String primaryFactor = "none";

    // =========================
    // BASE ALERT INPUT (NEW CORE UPGRADE)
    // =========================
    final alerts = _alertEngine.evaluate(cluster);

    for (final alert in alerts) {
      switch (alert.severity) {
        case AlertSeverity.critical:
          score += 40;
          reasons.add("Critical alert: ${alert.type}");
          primaryFactor = primaryFactor == "none" ? "alert" : primaryFactor;
          break;

        case AlertSeverity.high:
          score += 25;
          reasons.add("High alert: ${alert.type}");
          primaryFactor = primaryFactor == "none" ? "alert" : primaryFactor;
          break;

        case AlertSeverity.medium:
          score += 10;
          reasons.add("Medium alert: ${alert.type}");
          break;

        case AlertSeverity.low:
          score += 5;
          reasons.add("Low alert: ${alert.type}");
          break;
      }
    }

    // =========================
    // HEALTH FACTOR
    // =========================
    if (cluster.health < 0.2) {
      score += 50;
      reasons.add("Severe health degradation");
      primaryFactor = "health";
    } else if (cluster.health < 0.4) {
      score += 30;
      reasons.add("Low health detected");
      primaryFactor = primaryFactor == "none" ? "health" : primaryFactor;
    } else if (cluster.health < 0.7) {
      score += 10;
      reasons.add("Moderate health stress");
    }

    // =========================
    // STAGE FACTOR
    // =========================
    switch (cluster.stage) {
      case "seed":
        score += 10;
        reasons.add("Early stage monitoring required");
        break;

      case "sprout":
        score += 20;
        reasons.add("Sprouting stage care needed");
        break;

      case "growing":
        score += 15;
        reasons.add("Growth phase in progress");
        break;

      case "mature":
        score += 35;
        reasons.add("Harvest planning required");
        if (primaryFactor == "none") {
          primaryFactor = "harvest";
        }
        break;

      case "harvest":
        score += 5;
        reasons.add("Harvest completed or ready");
        break;
    }

    // =========================
    // HARVEST OVERRIDE
    // =========================
    if (cluster.isHarvested) {
      score = 0;
      reasons.clear();
      reasons.add("Crop already harvested");
      primaryFactor = "done";
    }

    // =========================
    // NORMALIZATION
    // =========================
    score = score.clamp(0, 100);

    // =========================
    // CLASSIFICATION
    // =========================
    late final PriorityLevel level;

    if (score >= 80) {
      level = PriorityLevel.critical;
    } else if (score >= 50) {
      level = PriorityLevel.high;
    } else if (score >= 20) {
      level = PriorityLevel.medium;
    } else {
      level = PriorityLevel.low;
    }

    return PriorityResult(
      level: level,
      score: score,
      reasons: reasons,
      primaryFactor: primaryFactor,
    );
  }
}