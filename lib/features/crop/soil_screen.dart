import 'package:flutter/material.dart';
import '../../app/app_state.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Enter Soil Details",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            buildField("pH Value", phController),
            buildField("Nitrogen", nController),
            buildField("Phosphorus", pController),
            buildField("Potassium", kController),
            buildField("Moisture", moistureController),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: soilType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Loamy",
                  child: Text("Loamy"),
                ),
                DropdownMenuItem(
                  value: "Clay",
                  child: Text("Clay"),
                ),
                DropdownMenuItem(
                  value: "Sandy",
                  child: Text("Sandy"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  soilType = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Recommendation"),
                      content: const Text("Recommended Crop: Rice"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            // ✅ FIXED CONNECTION
                            widget.state.openDigitalFarm();
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Analyze Soil",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}