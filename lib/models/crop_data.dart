class CropData {
  final String name;
  final double pHMin;
  final double pHMax;
  final String waterNeed;   // low / medium / high
  final String soilType;    // clay / loam / sandy / black
  final String climate;     // hot / humid / dry / moderate

  const CropData({
    required this.name,
    required this.pHMin,
    required this.pHMax,
    required this.waterNeed,
    required this.soilType,
    required this.climate,
  });
}