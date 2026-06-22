import 'treatment_plan_model.dart';
import 'treatment_checkpoint.dart';

class TreatmentInstance {
  final String disease;
  final TreatmentPlan template;

  final DateTime startDate;

  int progress;
  String status;

  List<TreatmentCheckpoint> checkpoints;

  TreatmentInstance({
    required this.disease,
    required this.template,
    required this.startDate,
    this.progress = 0,
    this.status = "active",
    required this.checkpoints,
  });

  TreatmentInstance copyWith({
    int? progress,
    String? status,
    List<TreatmentCheckpoint>? checkpoints,
  }) {
    return TreatmentInstance(
      disease: disease,
      template: template,
      startDate: startDate,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      checkpoints: checkpoints ?? this.checkpoints,
    );
  }
}