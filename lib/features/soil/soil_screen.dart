import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/crop_model.dart';
import '../../utils/asset_resolver.dart';

class SoilScreen extends StatefulWidget {
  final AppState state;

  const SoilScreen({
    super.key,
    required this.state,
  });

  @override
  State<SoilScreen> createState() => _SoilScreenState();
}

class _SoilScreenState extends State<SoilScreen> {
  final phController = TextEditingController();
  final nController = TextEditingController();
  final pController = TextEditingController();
  final kController = TextEditingController();
  final moistureController = TextEditingController();

  String soilType = "Loamy";

  @override
  void dispose() {
    phController.dispose();
    nController.dispose();
    pController.dispose();
    kController.dispose();
    moistureController.dispose();
    super.dispose();
  }

  String? _validate() {
    final ph = double.tryParse(phController.text);
    final n = int.tryParse(nController.text);
    final p = int.tryParse(pController.text);
    final k = int.tryParse(kController.text);
    final moisture = double.tryParse(moistureController.text);

    if (ph == null || ph < 0 || ph > 14) return "Invalid pH";
    if (n == null) return "Invalid Nitrogen";
    if (p == null) return "Invalid Phosphorus";
    if (k == null) return "Invalid Potassium";
    if (moisture == null || moisture < 0 || moisture > 100) {
      return "Invalid Moisture";
    }

    return null;
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    final ph = double.parse(phController.text);
    final n = int.parse(nController.text);
    final p = int.parse(pController.text);
    final k = int.parse(kController.text);
    final moisture = double.parse(moistureController.text);

    // ✅ STORE SOIL STATE IN APPSTATE (single source of truth)
    widget.state.setSoilData({
      "ph": ph,
      "n": n,
      "p": p,
      "k": k,
      "moisture": moisture,
      "soilType": soilType,
    });

    // ✅ Generate recommendations (temporary, later move to engine)
    final crops = _generateMock(ph, n, p, k, moisture);
    widget.state.setRecommendations(crops);

    // ✅ Switch tab (NO Navigator push chaos)
    widget.state.setTab(TabType.recommend);

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF4),
      appBar: AppBar(
        title: const Text("Soil Analysis"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field("pH", phController),
            _field("Nitrogen", nController),
            _field("Phosphorus", pController),
            _field("Potassium", kController),
            _field("Moisture", moistureController),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: soilType,
              items: const [
                DropdownMenuItem(value: "Loamy", child: Text("Loamy")),
                DropdownMenuItem(value: "Clay", child: Text("Clay")),
                DropdownMenuItem(value: "Sandy", child: Text("Sandy")),
              ],
              onChanged: (v) => setState(() => soilType = v!),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Analyze Soil"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  List<CropModel> _generateMock(
    double ph,
    int n,
    int p,
    int k,
    double moisture,
  ) {
    final crops = ["Rice", "Wheat", "Maize", "Millets"];

    return crops.map((crop) {
      double score = 50;

      if (crop == "Rice" && moisture > 60) score += 30;
      if (crop == "Wheat" && ph >= 6 && ph <= 7.5) score += 30;

      score += (n / 800) * 10;
      score += (p / 150) * 10;
      score += (k / 600) * 10;

      return CropModel(
        name: crop,
        score: score.clamp(0, 100),
        image: AssetResolver.cropImage(crop: crop),
      );
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }
}