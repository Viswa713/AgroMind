import '../models/scan_result.dart';
import '../models/farm_cluster_model.dart';
import '../models/save_decision.dart';

import '../data/disease_database.dart';

class DecisionEngine {
  static SaveDecision evaluate({
    required ScanResult scan,
    required List<FarmCluster> farmTiles,
  }) {
    // 1. get disease
    final disease = scan.disease;

    // 2. crops that can be affected by this disease
    final possibleCrops =
        DiseaseDatabase.getCropsForDisease(disease).toSet();

    // 3. crops actually present in user's farm
    final farmCrops =
        farmTiles.map((e) => e.crop.name).toSet();

    // 4. intersection (real valid targets)
    final matched = farmCrops.intersection(possibleCrops).toList();

    // 5. confidence rule (your system rule)
    final confidence = scan.confidence;

    final autoSave = confidence >= 70 && matched.length == 1;

    // 6. reason generation (for UI)
    final reason = _buildReason(
      disease: disease,
      matched: matched,
      confidence: confidence,
      autoSave: autoSave,
    );

    return SaveDecision(
      disease: disease,
      confidence: confidence,
      matchedCrops: matched,
      autoSave: autoSave,
      reason: reason,
    );
  }

  static String _buildReason({
    required String disease,
    required List<String> matched,
    required int confidence,
    required bool autoSave,
  }) {
    if (matched.isEmpty) {
      return "No matching crops found in your farm for $disease.";
    }

    if (autoSave) {
      return "Auto-saving: high confidence ($confidence%) and single crop match detected.";
    }

    return "Multiple possible crops found. User selection required.";
  }
}