class FarmTile {
  final String id;
  final String cropName;
  final List<String> diseases;

  const FarmTile({
    required this.id,
    required this.cropName,
    this.diseases = const [],
  });

  FarmTile copyWith({
    List<String>? diseases,
  }) {
    return FarmTile(
      id: id,
      cropName: cropName,
      diseases: diseases ?? this.diseases,
    );
  }
}