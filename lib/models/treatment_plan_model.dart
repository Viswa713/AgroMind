import 'treatment_log.dart';
import 'treatment_checkpoint.dart';
class TreatmentPlan {
  final String id;

  final String cropName;

  // disease
  final String disease;

  final String severity; // low | medium | high
  final String status; // ACTIVE | MONITORING | RESOLVED

  final DateTime createdAt;
  final DateTime? lastUpdated;

  final String expectedRecoveryRange;
  final DateTime nextScanDue;

  final List<String> steps;

  final int progress;

  final List<TreatmentLog> logs;
  final List<TreatmentCheckpoint> checkpoints;

  final List<ScanEntry> scanHistory;

  const TreatmentPlan({
    required this.id,
    required this.cropName,
    required this.disease,
    required this.severity,
    required this.status,
    required this.createdAt,
    this.lastUpdated,
    required this.expectedRecoveryRange,
    required this.nextScanDue,

    this.steps = const [],
    this.progress = 0,

    this.logs = const [],
    this.checkpoints = const [],
    this.scanHistory = const [],
  });

  factory TreatmentPlan.create({
    required String id,
    required String cropName,
    required String disease,
    required String severity,
  }) {
    final now = DateTime.now();

    return TreatmentPlan(
      id: id,
      cropName: cropName,
      disease: disease,
      severity: severity,
      status: "ACTIVE",
      createdAt: now,
      expectedRecoveryRange: _estimateRecovery(severity),
      nextScanDue: now.add(const Duration(days: 3)),
    );
  }

  TreatmentPlan copyWith({
    String? id,
    String? cropName,
    String? disease,
    String? severity,
    String? status,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? expectedRecoveryRange,
    DateTime? nextScanDue,
    List<String>? steps,
    int? progress,
    List<TreatmentLog>? logs,
    List<TreatmentCheckpoint>? checkpoints,
    List<ScanEntry>? scanHistory,
  }) {
    return TreatmentPlan(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      disease: disease ?? this.disease,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      expectedRecoveryRange:
          expectedRecoveryRange ?? this.expectedRecoveryRange,
      nextScanDue: nextScanDue ?? this.nextScanDue,
      steps: steps ?? this.steps,
      progress: progress ?? this.progress,
      logs: logs ?? this.logs,
      checkpoints: checkpoints ?? this.checkpoints,
      scanHistory: scanHistory ?? this.scanHistory,
    );
  }

  static String _estimateRecovery(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return "7–14 days (estimated)";
      case "medium":
        return "5–10 days (estimated)";
      case "low":
        return "3–7 days (estimated)";
      default:
        return "5–10 days (estimated)";
    }
  }
}

/// SCAN ENTRY
class ScanEntry {
  final DateTime timestamp;
  final double confidence;
  final double severityScore;
  final double spreadScore;

  const ScanEntry({
    required this.timestamp,
    required this.confidence,
    required this.severityScore,
    required this.spreadScore,
  });
}