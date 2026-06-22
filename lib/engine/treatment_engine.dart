import '../models/scan_result.dart';
import '../models/treatment_plan_model.dart';
import '../models/treatment_checkpoint.dart';

class TreatmentEngine {
  /// CREATE INITIAL PLAN FROM SCAN
  TreatmentPlan createPlan(ScanResult scan) {
    final now = DateTime.now();

    final plan = TreatmentPlan.create(
      id: "${scan.disease}_${now.millisecondsSinceEpoch}",
      cropName: "Unknown",
      disease: scan.disease,
      severity: _getSeverity(scan.confidence),
    );

    // attach checkpoints properly
    return plan.copyWith(
      checkpoints: buildTimeline(now),
    );
  }

  /// SEVERITY CALCULATION
  String _getSeverity(double confidence) {
    final s = 1 - (confidence / 100);

    if (s < 0.3) return "low";
    if (s < 0.7) return "medium";
    return "high";
  }

  /// UPDATE PLAN BASED ON NEW SCAN
  TreatmentPlan updatePlan(
    TreatmentPlan plan,
    ScanResult scan,
  ) {
    final severityScore = 1 - (scan.confidence / 100);

    final newSeverity = _getSeverity(scan.confidence);

    final newStatus = newSeverity == "high"
        ? "ACTIVE"
        : newSeverity == "medium"
            ? "MONITORING"
            : "RESOLVED";

    return plan.copyWith(
      severity: newSeverity,
      status: newStatus,
      nextScanDue: DateTime.now().add(const Duration(days: 3)),
      scanHistory: [
        ...plan.scanHistory,
        ScanEntry(
          timestamp: DateTime.now(),
          confidence: scan.confidence,
          severityScore: severityScore,
          spreadScore: severityScore,
        ),
      ],
    );
  }

  /// TIMELINE GENERATOR (UI SUPPORT)
  List<TreatmentCheckpoint> buildTimeline(DateTime startDate) {
    return [
      TreatmentCheckpoint(
        title: "Day 2 Check",
        type: "monitor",
        scheduledDate: startDate.add(const Duration(days: 2)),
        dayOffset: 2,
      ),
      TreatmentCheckpoint(
        title: "Day 5 Evaluation",
        type: "evaluation",
        scheduledDate: startDate.add(const Duration(days: 5)),
        dayOffset: 5,
      ),
      TreatmentCheckpoint(
        title: "Day 7 Mid Check",
        type: "evaluation",
        scheduledDate: startDate.add(const Duration(days: 7)),
        dayOffset: 7,
      ),
      TreatmentCheckpoint(
        title: "Day 10 Recovery Check",
        type: "evaluation",
        scheduledDate: startDate.add(const Duration(days: 10)),
        dayOffset: 10,
      ),
      TreatmentCheckpoint(
        title: "Day 14 Stability Check",
        type: "monitor",
        scheduledDate: startDate.add(const Duration(days: 14)),
        dayOffset: 14,
      ),
    ];
  }

  /// HELPER
  double calculateSeverity(ScanResult scan) {
    return (1 - (scan.confidence / 100)).clamp(0.0, 1.0);
  }
}