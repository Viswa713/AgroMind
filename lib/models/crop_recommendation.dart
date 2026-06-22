class CropRecommendation {
  final String name;
  final int durationDays;
  final int score;
  final double expectedFuturePrice;

  CropRecommendation({
    required this.name,
    required this.durationDays,
    required this.score,
    required this.expectedFuturePrice,
  });
}