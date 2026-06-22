import '../models/farm_cluster_model.dart';

enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

class Alert {
  final String type;
  final String message;
  final AlertSeverity severity;

  Alert({
    required this.type,
    required this.message,
    required this.severity,
  });
}

class AlertEngine {
  List<Alert> evaluate(FarmCluster zone) {
    final List<Alert> alerts = [];

    final double health = zone.health;
    final String stage = zone.stage;

    // =========================
    // HEALTH / WATER STRESS
    // =========================
    if (health < 0.2) {
      alerts.add(Alert(
        type: "HEALTH",
        message: "Crop is in critical condition",
        severity: AlertSeverity.critical,
      ));
    } else if (health < 0.3) {
      alerts.add(Alert(
        type: "WATER",
        message: "Severe water stress detected",
        severity: AlertSeverity.high,
      ));
    } else if (health < 0.6) {
      alerts.add(Alert(
        type: "WATER",
        message: "Moderate water requirement detected",
        severity: AlertSeverity.medium,
      ));
    } else {
      alerts.add(Alert(
        type: "STATUS",
        message: "Crop is stable",
        severity: AlertSeverity.low,
      ));
    }

    // =========================
    // STAGE-BASED ALERTS
    // =========================
    switch (stage) {
      case "seed":
        alerts.add(Alert(
          type: "GROWTH",
          message: "Early stage crop needs monitoring",
          severity: AlertSeverity.low,
        ));
        break;

      case "sprout":
        alerts.add(Alert(
          type: "GROWTH",
          message: "Sprouting stage requires stability",
          severity: AlertSeverity.medium,
        ));
        break;

      case "growing":
        alerts.add(Alert(
          type: "GROWTH",
          message: "Active growth phase ongoing",
          severity: AlertSeverity.medium,
        ));
        break;

      case "mature":
        alerts.add(Alert(
          type: "HARVEST",
          message: "Ready or near harvest stage",
          severity: AlertSeverity.high,
        ));
        break;

      case "harvest":
        alerts.add(Alert(
          type: "HARVEST",
          message: "Harvest completed or ready for removal",
          severity: AlertSeverity.critical,
        ));
        break;
    }

    // =========================
    // HARVEST OVERRIDE (IMPORTANT)
    // =========================
    if (zone.isHarvested) {
      alerts.clear();
      alerts.add(Alert(
        type: "HARVEST",
        message: "Crop already harvested",
        severity: AlertSeverity.low,
      ));
    }

    return alerts;
  }
}