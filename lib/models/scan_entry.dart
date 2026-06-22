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