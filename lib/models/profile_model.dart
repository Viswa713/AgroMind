class ProfileModel {
  final String name;
  final String location;
  final double? farmSize;
  final String? experienceLevel;
  final String? farmingType;

  const ProfileModel({
    required this.name,
    required this.location,
    this.farmSize,
    this.experienceLevel,
    this.farmingType,
  });

  ProfileModel copyWith({
    String? name,
    String? location,
    double? farmSize,
    String? experienceLevel,
    String? farmingType,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      location: location ?? this.location,
      farmSize: farmSize ?? this.farmSize,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      farmingType: farmingType ?? this.farmingType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "location": location,
      "farmSize": farmSize,
      "experienceLevel": experienceLevel,
      "farmingType": farmingType,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"],
      location: json["location"],
      farmSize: json["farmSize"],
      experienceLevel: json["experienceLevel"],
      farmingType: json["farmingType"],
    );
  }
}