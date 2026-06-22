import 'package:flutter/material.dart';

class FarmDecisionSnapshot {
  final String cropName;
  final String stage;
  final double progress;
  final double health;

  final bool needsWater;
  final String waterUrgency;
  final int waterMinutes;

  final String growthStage;
  final String priorityLevel;

  final Color priorityColor;
  final IconData priorityIcon;

  const FarmDecisionSnapshot({
    required this.cropName,
    required this.stage,
    required this.progress,
    required this.health,
    required this.needsWater,
    required this.waterUrgency,
    required this.waterMinutes,
    required this.growthStage,
    required this.priorityLevel,
    required this.priorityColor,
    required this.priorityIcon,
  });

  static FarmDecisionSnapshot empty() {
    return FarmDecisionSnapshot(
      cropName: "Empty",
      stage: "none",
      progress: 0,
      health: 0,
      needsWater: false,
      waterUrgency: "NONE",
      waterMinutes: 0,
      growthStage: "none",
      priorityLevel: "none",
      priorityColor: Colors.grey,
      priorityIcon: Icons.add,
    );
  }
}