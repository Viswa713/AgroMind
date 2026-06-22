import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../app/app_state.dart';
import '../../app/app_state.dart' show TabType;
import '../../models/scan_result.dart';

import '../auth/login_screen.dart';
import 'plan_screen.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  final AppState state;

  const DiseaseDetectionScreen({
    super.key,
    required this.state,
  });

  @override
  State<DiseaseDetectionScreen> createState() =>
      _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? selectedImage;
  bool isProcessing = false;

  Map<String, dynamic>? uiResult;

  final ImagePicker picker = ImagePicker();

  bool get _isLoggedIn => widget.state.isLoggedIn;

  // =========================
  // IMAGE PICKING
  // =========================
  Future<void> openCamera() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    _startProcessing(File(image.path));
  }

  Future<void> openGallery() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    _startProcessing(File(image.path));
  }

  void _startProcessing(File imageFile) {
    setState(() {
      selectedImage = imageFile;
      isProcessing = true;
      uiResult = null;
    });

    _runInference();
  }

  // =========================
  // ML CALL (CLEAN CONTRACT)
  // =========================
Future<void> _runInference() async {
  try {
    debugPrint("SENDING IMAGE PATH: ${selectedImage!.path}");
    debugPrint("FILE EXISTS: ${File(selectedImage!.path).existsSync()}");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.1.6:8000/predict"),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        selectedImage!.path,
      ),
    );

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    debugPrint("ML RESPONSE: $responseBody");

    final decoded = jsonDecode(responseBody);

    setState(() {
      isProcessing = false;
      uiResult = {
        "disease": decoded["disease"],
        "confidence": (decoded["confidence"] as num).toDouble().round(),
        "pesticide": decoded["pesticide"] ?? "Unknown",
        "treatment": decoded["treatment"] ?? [],
      };
    });
  } catch (e) {
    setState(() {
      isProcessing = false;
      uiResult = {
        "disease": "error",
        "confidence": 0,
        "pesticide": "Unknown",
        "treatment": ["ML inference failed"],
      };
    });

    debugPrint("ML ERROR: $e");
  }
}
 // RESET
  // =========================
  void resetScan() {
    setState(() {
      selectedImage = null;
      isProcessing = false;
      uiResult = null;
    });
  }

  // =========================
  // NAVIGATION
  // =========================
  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(state: widget.state),
      ),
    );
  }

  void saveToFarm() {
    if (!_isLoggedIn) {
      goToLogin();
      return;
    }

    if (uiResult == null) return;

    final scanResult = ScanResult(
      disease: uiResult!['disease'],
      confidence: (uiResult!['confidence'] as num).toDouble(),
    );

    widget.state.processFullScanFlow(scanResult);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved to Farm")),
    );

    widget.state.setTab(TabType.home);
  }

  void createPlan() {
    if (!_isLoggedIn) {
      goToLogin();
      return;
    }

    if (uiResult == null) return;

    final scanResult = ScanResult(
      disease: uiResult!['disease'],
      confidence: (uiResult!['confidence'] as num).toDouble(),
    );

    final plan = widget.state.engine.createPlan(scanResult);

    widget.state.processFullScanFlow(scanResult);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlanScreen(
          state: widget.state,
          plan: widget.state.activePlan!,
        ),
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disease Detection"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(14),
              ),
              child: selectedImage == null
                  ? const Center(
                      child: Icon(Icons.camera_alt,
                          size: 60, color: Colors.green),
                    )
                  : Image.file(selectedImage!, fit: BoxFit.cover),
            ),

            const SizedBox(height: 20),

            if (selectedImage == null) ...[
              ElevatedButton(
                onPressed: openCamera,
                child: const Text("Camera"),
              ),
              ElevatedButton(
                onPressed: openGallery,
                child: const Text("Upload"),
              ),
            ],

            if (isProcessing)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),

            if (uiResult != null && !isProcessing)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Disease: ${uiResult!['disease']}"),
                    Text("Confidence: ${uiResult!['confidence']}%"),
                    Text("Pesticide: ${uiResult!['pesticide']}"),

                    const SizedBox(height: 10),

                    const Text(
                      "Treatment Plan:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    ...(uiResult!['treatment'] as List)
                        .map((e) => Text("• $e"))
                        .toList(),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: saveToFarm,
                      child: const Text("Save To Farm"),
                    ),
                    ElevatedButton(
                      onPressed: createPlan,
                      child: const Text("Create Plan"),
                    ),
                    ElevatedButton(
                      onPressed: resetScan,
                      child: const Text("Scan Again"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}