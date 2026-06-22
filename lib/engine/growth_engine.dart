import '../models/farm_cluster_model.dart';

class GrowthResult {
  final String stage;
  final double progress;
  final String note;

  GrowthResult({
    required this.stage,
    required this.progress,
    required this.note,
  });
}

class GrowthEngine {
  /// Simulation speed factor
  static const int timeScale = 24; // 1 sec = 1 hour (demo mode)

  GrowthResult evaluate(FarmCluster zone) {
    final seconds = DateTime.now()
        .difference(zone.plantedAt)
        .inSeconds;

    // simulated time conversion
    final simulatedHours = seconds * timeScale;
    final safeDays = simulatedHours / 24;

    String stage;
    double progress;

    // =========================
    // 5-STAGE GROWTH MODEL
    // =========================
    if (safeDays < 3) {
      stage = "seed";
      progress = safeDays / 3;
    } else if (safeDays < 10) {
      stage = "sprout";
      progress = (safeDays - 3) / 7;
    } else if (safeDays < 25) {
      stage = "growing";
      progress = (safeDays - 10) / 15;
    } else if (safeDays < 40) {
      stage = "mature";
      progress = (safeDays - 25) / 15;
    } else {
      stage = "harvest";
      progress = 1.0;
    }

    return GrowthResult(
      stage: stage,
      progress: progress.clamp(0.0, 1.0),
      note: "SIMULATED FARM LIFECYCLE",
    );
  }
}