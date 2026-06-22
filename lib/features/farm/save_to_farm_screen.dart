import 'package:flutter/material.dart';
import '../../app/app_state.dart';

class SaveToFarmScreen extends StatefulWidget {
  final AppState state;

  const SaveToFarmScreen({
    super.key,
    required this.state,
  });

  @override
  State<SaveToFarmScreen> createState() => _SaveToFarmScreenState();
}

class _SaveToFarmScreenState extends State<SaveToFarmScreen> {
  int? selectedTile;

  @override
  Widget build(BuildContext context) {
    final decision = widget.state.lastDecision;

    if (decision == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Save to Farm"),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text("No scan decision found"),
        ),
      );
    }

    final matched = decision.matchedCrops;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Save to Farm"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // DISEASE SUMMARY
            // =========================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    decision.diseaseName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Confidence: ${decision.confidence}%"),
                  const SizedBox(height: 6),
                  Text(
                    decision.autoSave
                        ? "Auto-save enabled"
                        : "Manual selection required",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Matched Crops in Your Farm",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // NO MATCH CASE
            // =========================
            if (matched.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No matching crops found in farm"),
                ),
              ),

            // =========================
            // AUTO SAVE CASE
            // =========================
            if (matched.length == 1 && decision.autoSave)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Auto-selected Crop:",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        matched.first,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // =========================
            // MULTIPLE MATCH CASE
            // =========================
            if (matched.length > 1 || !decision.autoSave)
              Expanded(
                child: ListView.builder(
                  itemCount: matched.length,
                  itemBuilder: (context, index) {
                    final cropName = matched[index];

                    final isSelected = selectedTile == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTile = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          color: isSelected
                              ? Colors.green.shade50
                              : Colors.white,
                        ),
                        child: Text(
                          cropName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),

            // =========================
            // ACTION BUTTONS
            // =========================

            if (matched.length == 1 && decision.autoSave)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.state.saveToSelectedTile(0);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Saved automatically to farm"),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text("Confirm Auto Save"),
                ),
              ),

            if (matched.length > 1 || !decision.autoSave)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedTile == null
                      ? null
                      : () {
                          widget.state.saveToSelectedTile(selectedTile!);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Saved to selected tile"),
                            ),
                          );

                          Navigator.pop(context);
                        },
                  child: const Text("Save to Selected Tile"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}