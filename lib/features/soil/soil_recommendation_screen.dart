import 'package:flutter/material.dart';
import '../models/crop_recommendation.dart';
import '../app/app_state.dart';
import 'crop_recommendation_screen.dart';

class SoilRecommendationScreen extends StatelessWidget {
  final AppState state;

  const SoilRecommendationScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {

    final crops = [
      CropRecommendation(name: "Rice", durationDays: 90, score: 95, expectedFuturePrice: 22),
      CropRecommendation(name: "Wheat", durationDays: 110, score: 85, expectedFuturePrice: 25),
      CropRecommendation(name: "Maize", durationDays: 80, score: 75, expectedFuturePrice: 18),
      CropRecommendation(name: "Cotton", durationDays: 150, score: 60, expectedFuturePrice: 55),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Soil Analysis")),
      body: Center(
        child: ElevatedButton(
         onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CropRecommendationScreen(
        crops: crops,
        state: state,
      ),
    ),
  );
},
          child: const Text("Get Recommendations"),
        ),
      ),
    );
  }
}