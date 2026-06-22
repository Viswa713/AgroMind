class SoilProfile {
  final double ph;
  final int n;
  final int p;
  final int k;
  final double moisture;
  final String soilType;
  final DateTime createdAt;

  SoilProfile({
    required this.ph,
    required this.n,
    required this.p,
    required this.k,
    required this.moisture,
    required this.soilType,
    required this.createdAt,
  });
}