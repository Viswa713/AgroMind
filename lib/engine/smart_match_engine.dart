import '../models/farm_cluster_model.dart';
import '../models/scan_result.dart';
import '../data/crop_database.dart';

class SmartMatchEngine {
  static List<String> findMatchingCrops({
    required ScanResult scan,
    required List<FarmCluster> farmCrops,
  }) {
    final disease = scan.disease.toLowerCase();

    // 1. crops that can have this disease (from DB logic placeholder)
    final possibleCrops = CropDatabase.crops
        .where((crop) => _canCropHaveDisease(crop.name, disease))
        .map((e) => e.name)
        .toSet();

    // 2. actual farm crops
    final farmCropNames = farmCrops
        .map((e) => e.crop.name)
        .toSet();

    // 3. intersection = real candidates
    final matches = farmCropNames.intersection(possibleCrops);

    return matches.toList();
  }

  /// ⚠️ TEMP RULE ENGINE (replace later with ML/API)
  static bool _canCropHaveDisease(String crop, String disease) {
    final c = crop.toLowerCase();
    final d = disease.toLowerCase();

    // example logic rules
    if (d.contains("blight")) {
      return c == "rice" || c == "potato" || c == "tomato";
    }

    if (d.contains("wilt")) {
      return c == "banana" || c == "cotton";
    }

    if (d.contains("rust")) {
      return c == "wheat" || c == "maize";
    }

    // fallback: unknown disease → allow all
    return true;
  }
}