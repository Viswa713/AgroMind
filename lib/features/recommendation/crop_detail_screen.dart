import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/crop_model.dart';
import '../auth/login_screen.dart';
import '../../app/app_state.dart' show TabType;

class CropDetailScreen extends StatelessWidget {
  final CropModel crop;
  final AppState state;

  const CropDetailScreen({
    super.key,
    required this.crop,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(crop.image),
            ),

            const SizedBox(height: 16),

            Text(
              crop.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Recommended Score: ${crop.score.toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // DETAILS
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Growth duration: ${crop.duration}"),
                  const SizedBox(height: 6),
                  Text("Water requirement: ${crop.waterNeed}"),
                  const SizedBox(height: 6),
                  Text("Soil preference: ${crop.soilPreference}"),
                  const SizedBox(height: 6),
                  Text("Market demand: ${crop.marketDemand}"),
                ],
              ),
            ),

            const Spacer(),

            // =====================
            // SELECT BUTTON (FIXED)
            // =====================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  // =====================
                  // NOT LOGGED IN FLOW
                  // =====================
                  if (!state.isLoggedIn) {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Login required",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "You need to log in to select and save this crop.",
                              ),

                              const SizedBox(height: 16),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          LoginScreen(state: state),
                                    ),
                                  );
                                },
                                child: const Text("Login"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    return;
                  }

                  // =====================
                  // LOGGED IN FLOW (ORIGINAL)
                  // =====================
                  if (state.selectedTileIndex != null) {
                    state.assignCropToSlot(
                      state.selectedTileIndex!,
                      crop,
                    );
                  } else {
                    state.plantCropAuto(crop);
                  }

                  state.clearSelections();
                  state.setTab(TabType.home);

                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text("Select Crop"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SAFE IMAGE
  Widget _buildImage(String path) {
    if (path.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Image.asset(
      path,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }
}