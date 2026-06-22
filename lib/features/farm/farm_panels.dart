import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/farm_decision_snapshot.dart';

class FarmPanels {

  // =========================
  // 🌱 CROP PANEL
  // =========================
  static void showCropPanel(
    BuildContext context,
    AppState state,
    int index,
  ) {
    final snapshot = state.getSnapshot(index);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Crop Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.eco),
                title: Text("Crop: ${snapshot.cropName}"),
                subtitle: Text("Stage: ${snapshot.stage}"),
              ),

              const SizedBox(height: 10),

              const Text("Growth Progress"),
              const SizedBox(height: 8),

              LinearProgressIndicator(value: snapshot.progress),

              const SizedBox(height: 5),

              Text("${(snapshot.progress * 100).toInt()}% completed"),

              const SizedBox(height: 15),

              ListTile(
                leading: const Icon(Icons.water_drop),
                title: const Text("Watering"),
                subtitle: Text(
                  snapshot.needsWater
                      ? "Needs ${snapshot.waterMinutes} min watering"
                      : "No watering needed",
                ),
              ),

              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text("Priority"),
                subtitle: Text(snapshot.waterUrgency),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // 🌱 SOIL PANEL
  // =========================
  static void showSoilPanel(
    BuildContext context,
    AppState state,
    int index,
  ) {
    final snapshot = state.getSnapshot(index);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _SoilPanel(
          snapshot: snapshot,
          state: state,
        );
      },
    );
  }
}

// ======================================================
// 🌱 SOIL PANEL UI
// ======================================================

class _SoilPanel extends StatefulWidget {
  final FarmDecisionSnapshot snapshot;
  final AppState state;

  const _SoilPanel({
    required this.snapshot,
    required this.state,
  });

  @override
  State<_SoilPanel> createState() => _SoilPanelState();
}

class _SoilPanelState extends State<_SoilPanel> {
  bool showAdvanced = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snapshot;
    final soil = widget.state.soilData;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            "Soil Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.terrain),
            title: const Text("Soil Type"),
            subtitle: Text("${soil?['soilType'] ?? '--'}"),
          ),

          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("Health Status"),
            subtitle: Text(
              snapshot.health > 0.7 ? "Healthy" : "Needs Attention",
            ),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                showAdvanced = !showAdvanced;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showAdvanced
                        ? "Hide Advanced Data"
                        : "Show Soil Details",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.expand_more),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          if (showAdvanced)
            Column(
              children: [
                const Divider(),

                ListTile(
                  title: const Text("pH Level"),
                  subtitle: Text("${soil?['ph'] ?? '--'}"),
                ),

                ListTile(
                  title: const Text("Nitrogen (N)"),
                  subtitle: Text("${soil?['n'] ?? '--'}"),
                ),

                ListTile(
                  title: const Text("Phosphorus (P)"),
                  subtitle: Text("${soil?['p'] ?? '--'}"),
                ),

                ListTile(
                  title: const Text("Potassium (K)"),
                  subtitle: Text("${soil?['k'] ?? '--'}"),
                ),

                ListTile(
                  title: const Text("Moisture"),
                  subtitle: Text("${soil?['moisture'] ?? '--'}%"),
                ),

                ListTile(
                  title: const Text("Soil Type"),
                  subtitle: Text("${soil?['soilType'] ?? '--'}"),
                ),
              ],
            ),
        ],
      ),
    );
  }
}