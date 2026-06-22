class SaveDecision {
  final String disease;
  final int confidence;
  final List<String> matchedCrops;
  final bool autoSave;
  final String reason;

  const SaveDecision({
    required this.disease,
    required this.confidence,
    required this.matchedCrops,
    required this.autoSave,
    required this.reason,
  });
}