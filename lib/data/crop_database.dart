import '../models/crop_data.dart';

class CropDatabase {
  static const List<CropData> crops = [

    // 🌾 Paddy ecosystem
    CropData(
      name: "Rice",
      pHMin: 5.5,
      pHMax: 7.0,
      waterNeed: "high",
      soilType: "clay",
      climate: "humid",
    ),

    CropData(
      name: "Sugarcane",
      pHMin: 6.0,
      pHMax: 7.5,
      waterNeed: "high",
      soilType: "loam",
      climate: "hot",
    ),

    CropData(
      name: "Banana",
      pHMin: 5.5,
      pHMax: 7.0,
      waterNeed: "high",
      soilType: "loam",
      climate: "humid",
    ),

    CropData(
      name: "Coconut",
      pHMin: 6.0,
      pHMax: 7.5,
      waterNeed: "medium",
      soilType: "sandy",
      climate: "humid",
    ),

    // 🌱 Pulses / low input crops
    CropData(
      name: "Groundnut",
      pHMin: 6.0,
      pHMax: 7.5,
      waterNeed: "low",
      soilType: "sandy",
      climate: "hot",
    ),

    CropData(
      name: "Green Gram",
      pHMin: 6.0,
      pHMax: 7.0,
      waterNeed: "low",
      soilType: "loam",
      climate: "hot",
    ),

    CropData(
      name: "Black Gram",
      pHMin: 6.0,
      pHMax: 7.5,
      waterNeed: "low",
      soilType: "loam",
      climate: "hot",
    ),

    CropData(
      name: "Sesame",
      pHMin: 5.5,
      pHMax: 7.5,
      waterNeed: "low",
      soilType: "sandy",
      climate: "dry",
    ),

    // 🌾 Cereals
    CropData(
      name: "Maize",
      pHMin: 5.8,
      pHMax: 7.2,
      waterNeed: "medium",
      soilType: "loam",
      climate: "hot",
    ),

    CropData(
      name: "Millets",
      pHMin: 5.5,
      pHMax: 7.5,
      waterNeed: "low",
      soilType: "sandy",
      climate: "dry",
    ),

    CropData(
      name: "Sorghum",
      pHMin: 5.5,
      pHMax: 7.5,
      waterNeed: "low",
      soilType: "mixed",
      climate: "dry",
    ),

    // 🌿 Commercial crops
    CropData(
      name: "Cotton",
      pHMin: 6.0,
      pHMax: 8.0,
      waterNeed: "low",
      soilType: "black",
      climate: "hot",
    ),

    CropData(
      name: "Chilli",
      pHMin: 6.0,
      pHMax: 7.5,
      waterNeed: "medium",
      soilType: "loam",
      climate: "hot",
    ),

    CropData(
      name: "Turmeric",
      pHMin: 5.5,
      pHMax: 7.5,
      waterNeed: "medium",
      soilType: "loam",
      climate: "humid",
    ),

    CropData(
      name: "Tapioca",
      pHMin: 5.5,
      pHMax: 7.0,
      waterNeed: "medium",
      soilType: "sandy",
      climate: "humid",
    ),

  ];
}