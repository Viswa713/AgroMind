import 'crop_model.dart';

class FarmCluster {
  final CropModel crop;

  final String stage;
  final double health;
  final double progress;
  final DateTime plantedAt;
  final bool isHarvested;

  // =========================
  // ENGINE OUTPUT FIELDS
  // =========================
  final String? priorityLevel;
  final String? irrigationStatus;
  final List<dynamic>? alerts;

  FarmCluster({
    required this.crop,
    required this.stage,
    required this.health,
    required this.plantedAt,
    this.progress = 0.0,
    this.isHarvested = false,
    this.priorityLevel,
    this.irrigationStatus,
    this.alerts,
  });

  FarmCluster copyWith({
    CropModel? crop,
    String? stage,
    double? health,
    double? progress,
    DateTime? plantedAt,
    bool? isHarvested,
    String? priorityLevel,
    String? irrigationStatus,
    List<dynamic>? alerts,
  }) {
    return FarmCluster(
      crop: crop ?? this.crop,
      stage: stage ?? this.stage,
      health: health ?? this.health,
      progress: progress ?? this.progress,
      plantedAt: plantedAt ?? this.plantedAt,
      isHarvested: isHarvested ?? this.isHarvested,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      irrigationStatus: irrigationStatus ?? this.irrigationStatus,
      alerts: alerts ?? this.alerts,
    );
  }

  bool get hasDisease => (alerts ?? []).any((a) => a.type == "DISEASE");
}