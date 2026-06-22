class Recommendation {
  final String title;
  final String detail;
  final String priority;

  final bool hasDisease;
  final bool needsIrrigation;
  final double healthScore;

  const Recommendation({
    required this.title,
    required this.detail,
    required this.priority,
    required this.hasDisease,
    required this.needsIrrigation,
    required this.healthScore,
  });
}