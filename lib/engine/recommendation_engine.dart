import '../models/farm_cluster_model.dart';
import '../models/recommendation.dart';

import 'priority_engine.dart';
import 'alert_engine.dart';
import 'irrigation_engine.dart';
import 'growth_engine.dart';

class RecommendationEngine {
  final PriorityEngine priorityEngine = PriorityEngine();
  final AlertEngine alertEngine = AlertEngine();
  final IrrigationEngine irrigationEngine = IrrigationEngine();
  final GrowthEngine growthEngine = GrowthEngine();

  Recommendation generate(FarmCluster zone) {
    final priority = priorityEngine.evaluate(zone);
    final alerts = alertEngine.evaluate(zone);
    final irrigation = irrigationEngine.evaluate(zone);
    final growth = growthEngine.evaluate(zone);

    final hasDisease = alerts.any((a) => a.type == "DISEASE");
    final needsWater = irrigation.needsWater;
    final healthScore = growth.healthScore;

    String title;
    String detail;

    if (hasDisease) {
      title = "Disease Detected";
      detail = "Immediate action required to protect crop health.";
    } 
    else if (needsWater) {
      title = "Irrigation Needed";
      detail =
          "Water for ${irrigation.recommendedMinutes} minutes (urgency: ${irrigation.urgency}).";
    } 
    else if (priority.level.name == "critical") {
      title = "Critical Attention Required";
      detail = priority.reason;
    } 
    else {
      title = "Farm Stable";
      detail = "No immediate action required.";
    }

    return Recommendation(
      title: title,
      detail: detail,
      priority: priority.level.name.toUpperCase(),
      hasDisease: hasDisease,
      needsIrrigation: needsWater,
      healthScore: healthScore,
    );
  }
}