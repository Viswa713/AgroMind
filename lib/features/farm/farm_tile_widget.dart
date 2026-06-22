import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/farm_cluster_model.dart';
import '../../models/farm_decision_snapshot.dart';
import '../../utils/asset_resolver.dart';
import 'farm_panels.dart';

class FarmTileWidget extends StatelessWidget {
  final int index;
  final AppState state;

  const FarmTileWidget({
    super.key,
    required this.index,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final FarmCluster? cluster = state.farmGrid[index];
    final bool isEmpty = cluster == null;

    final FarmDecisionSnapshot? decision =
        cluster != null ? state.getSnapshot(index) : null;

    final isSelected = state.selectedTileIndex == index;

    final isCropSelected =
        isSelected && state.selectionType == TileSelectionType.crop;

    final isSoilSelected =
        isSelected && state.selectionType == TileSelectionType.soil;

    final String? imagePath = decision != null
        ? AssetResolver.cropImage(
            crop: decision.cropName,
            stage: decision.stage,
          )
        : null;

    return Column(
      children: [
        // 🌱 CROP SECTION
        Expanded(
          flex: 6,
          child: GestureDetector(
            onTap: () {
              if (isEmpty) {
                state.selectCrop(index);
                state.setTab(TabType.recommend);
                return;
              }

              state.selectCrop(index);
              FarmPanels.showCropPanel(context, state, index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isEmpty
                    ? Colors.grey.shade300
                    : Colors.green.shade100,
                border: isCropSelected
                    ? Border.all(color: Colors.yellow, width: 2)
                    : null,
              ),
              child: Stack(
                children: [
                  // 🌱 CROP IMAGE WITH ANIMATION
                  Center(
                    child: isEmpty
                        ? const Icon(
                            Icons.add,
                            color: Colors.black54,
                            size: 20,
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: _buildCropImage(
                              imagePath,
                              key: ValueKey(imagePath),
                            ),
                          ),
                  ),

                  // 🟢 HEALTH DOT (ANIMATED)
                  if (decision != null)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: _dot(_healthColor(decision.health)),
                    ),

                  // 🚨 PRIORITY ICON (ANIMATED)
                  if (decision != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: AnimatedScale(
                        scale: decision.priorityLevel == "critical"
                            ? 1.3
                            : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          decision.priorityIcon,
                          color: decision.priorityColor,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 🌍 SOIL SECTION
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              state.selectSoil(index);
              FarmPanels.showSoilPanel(context, state, index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: isSoilSelected
                    ? Border.all(color: Colors.orange, width: 2)
                    : null,
              ),
              child: Column(
                children: [
                  Expanded(child: Container(color: Colors.brown.shade300)),
                  Expanded(child: Container(color: Colors.brown.shade400)),
                  Expanded(child: Container(color: Colors.brown.shade500)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // CROP IMAGE
  // =========================
  Widget _buildCropImage(String? path, {Key? key}) {
    if (path == null || path.isEmpty) {
      return const Icon(
        Icons.eco,
        color: Colors.green,
        size: 30,
      );
    }

    return Image.asset(
      path,
      key: key,
      fit: BoxFit.cover,
      errorBuilder: (_, error, __) {
        debugPrint("FAILED IMAGE LOAD: $path");
        return const Icon(
          Icons.eco,
          color: Colors.green,
          size: 30,
        );
      },
    );
  }

  // =========================
  // HEALTH COLOR
  // =========================
  Color _healthColor(double health) {
    if (health >= 0.8) return Colors.green;
    if (health >= 0.5) return Colors.orange;
    return Colors.red;
  }

  // =========================
  // ANIMATED HEALTH DOT
  // =========================
  Widget _dot(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
    );
  }
}