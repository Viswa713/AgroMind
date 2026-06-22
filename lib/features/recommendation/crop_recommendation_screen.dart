import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/crop_model.dart';
import 'crop_detail_screen.dart';

class CropRecommendationScreen extends StatelessWidget {
  final AppState state;

  const CropRecommendationScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final List<CropModel> crops = state.recommendedCrops;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Ranking"),
        backgroundColor: Colors.green,
      ),

      body: crops.isEmpty
          ? const Center(
              child: Text(
                "No recommendations available.\nAdd soil data first.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CropDetailScreen(
                          crop: crop,
                          state: state,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black12,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: _buildImage(crop.image),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  crop.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Tap to view details and plant",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${crop.score.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildImage(String path) {
    if (path.isEmpty) {
      return Container(
        width: 90,
        height: 90,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Image.asset(
      path,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: 90,
          height: 90,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }
}