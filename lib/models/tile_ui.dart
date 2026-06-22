import 'package:flutter/material.dart';

class TileUI {
  final String cropImage;
  final String healthLevel;   // instead of Color
  final String priorityLevel; // instead of Icon + Color

  const TileUI({
    required this.cropImage,
    required this.healthLevel,
    required this.priorityLevel,
  });

  factory TileUI.empty() {
    return const TileUI(
      cropImage: '',
      healthLevel: 'low',
      priorityLevel: 'none',
    );
  }
}