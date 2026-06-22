import 'dart:async';
import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../models/farm_cluster_model.dart';
import '../models/crop_model.dart';
import '../models/farm_decision_snapshot.dart';
import '../models/scan_result.dart';
import '../models/save_decision.dart';
import '../models/soil_profile_model.dart';
import '../models/treatment_plan_model.dart';

import '../engine/priority_engine.dart';
import '../engine/treatment_engine.dart';
import '../engine/alert_engine.dart';
import '../engine/growth_engine.dart';
import '../engine/irrigation_engine.dart';
import '../engine/smart_match_engine.dart';

enum TabType { home, scan, recommend, profile }
enum TileSelectionType { none, crop, soil }

class AppState extends ChangeNotifier {

  // =========================================================
  // 🔐 AUTH LAYER
  // =========================================================

  bool isLoggedIn = false;

  void loginSuccess() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    tab = TabType.home;

    clearAllState();

    farmGrid = List.generate(9, (_) => null);

    notifyListeners();
  }

  Future<void> requireLogin(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    if (isLoggedIn) {
      await action();
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("You need to log in."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Login"),
          ),
        ],
      ),
    );

    if (result == true) {
      Navigator.pushNamed(context, "/login");
    }
  }

  // =========================================================
  // 🌱 FARM + ENGINE LAYER
  // =========================================================

  final PriorityEngine _priorityEngine = PriorityEngine();
  final AlertEngine _alertEngine = AlertEngine();
  final GrowthEngine _growthEngine = GrowthEngine();
  final IrrigationEngine _irrigationEngine = IrrigationEngine();
  final TreatmentEngine engine = TreatmentEngine();

  Timer? _farmTimer;
  bool _initialized = false;

  AppState() {
    _init();
  }

  void _init() {
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFarmLoop();
    });
  }

  void _startFarmLoop() {
    _farmTimer?.cancel();

    _farmTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _updateFarmState();
        notifyListeners();
      },
    );
  }

  void _updateFarmState() {
    for (int i = 0; i < farmGrid.length; i++) {
      final cluster = farmGrid[i];
      if (cluster == null) continue;

      final growth = _growthEngine.evaluate(cluster);

      farmGrid[i] = cluster.copyWith(
        stage: growth.stage,
        progress: growth.progress,
      );
    }
  }

  @override
  void dispose() {
    _farmTimer?.cancel();
    super.dispose();
  }

  List<FarmCluster?> farmGrid = List.generate(9, (_) => null);

  void assignCropToSlot(int index, CropModel crop) {
    farmGrid[index] = FarmCluster(
      crop: crop,
      stage: "seed",
      health: 1.0,
      progress: 0.0,
      plantedAt: DateTime.now(),
      isHarvested: false,
    );

    notifyListeners();
  }

  void updateCluster(int index, FarmCluster updated) {
    farmGrid[index] = updated;
    notifyListeners();
  }

  // =========================================================
  // 📸 SCAN + TREATMENT SYSTEM (FINAL CLEAN ARCHITECTURE)
  // =========================================================

  ScanResult? lastScan;
  SaveDecision? lastDecision;

  List<TreatmentPlan> treatmentHistory = [];
  TreatmentPlan? activePlan;

  final Set<String> activatedPlanIds = {};

  void setScanResult(ScanResult result) {
    lastScan = result;
    notifyListeners();
  }

  void processFullScanFlow(ScanResult result) {
    setScanResult(result);

    final plan = engine.createPlan(result);

    addTreatmentPlan(plan);

    activateTreatmentUI();

    processSaveToFarm();

    notifyListeners();
  }

  void addTreatmentPlan(TreatmentPlan plan) {
    treatmentHistory.add(plan);
    activePlan = plan;
    notifyListeners();
  }

  void activatePlan(String planId) {
    activatedPlanIds.add(planId);

    activePlan = treatmentHistory.firstWhere(
      (p) => p.id == planId,
      orElse: () => activePlan!,
    );

    notifyListeners();
  }

  bool isPlanActivated(String planId) {
    return activatedPlanIds.contains(planId);
  }

  void processSaveToFarm() {
    if (lastScan == null) return;

    final farmCrops = farmGrid.whereType<FarmCluster>().toList();

    final matches = SmartMatchEngine.findMatchingCrops(
      scan: lastScan!,
      farmCrops: farmCrops,
    );

    final confidence = lastScan!.confidence;
    final autoSave = confidence > 70 && matches.length == 1;

    lastDecision = SaveDecision(
      disease: lastScan!.disease,
      confidence: confidence.toInt(),
      matchedCrops: matches,
      autoSave: autoSave,
      reason: autoSave ? "Auto-save triggered" : "Manual review needed",
    );

    notifyListeners();
  }

  // =========================================================
  // 🎨 UI STATE LAYER
  // =========================================================

  bool showTreatmentQuickAccess = false;
  bool showScanResultBanner = false;
  bool showRecommendationHighlight = false;

  void activateTreatmentUI() {
    showTreatmentQuickAccess = true;
    notifyListeners();
  }

  void clearTreatmentUI() {
    showTreatmentQuickAccess = false;
    notifyListeners();
  }

  // =========================================================
  // 🧭 TAB SYSTEM
  // =========================================================

  TabType tab = TabType.home;

  void setTab(TabType newTab) {
    tab = newTab;
    notifyListeners();
  }

  // =========================================================
  // 🌿 SOIL SYSTEM (RESTORED FOR UI COMPATIBILITY)
  // =========================================================

  Map<String, dynamic>? soilData;
  SoilProfile? soilProfile;

  void setSoilData(Map<String, dynamic> data) {
    soilData = data;
    notifyListeners();
  }

  void setSoilProfile(SoilProfile soil) {
    soilProfile = soil;
    notifyListeners();
  }

  // =========================================================
  // 👤 PROFILE SYSTEM (RESTORED)
  // =========================================================

  ProfileModel? profile;

  void saveProfile(ProfileModel p) {
    profile = p;
    notifyListeners();
  }

  void updateProfile(ProfileModel p) {
    profile = p;
    notifyListeners();
  }

  // =========================================================
  // 🌾 RECOMMENDATION SYSTEM (RESTORED)
  // =========================================================

  List<CropModel> recommendedCrops = [];

  List<CropModel> get recommendations => recommendedCrops;

  void setRecommendations(List<CropModel> crops) {
    recommendedCrops = List.from(crops);
    notifyListeners();
  }

  void clearRecommendations() {
    recommendedCrops.clear();
    notifyListeners();
  }

  // =========================================================
  // 🌱 FARM SELECTION SYSTEM (RESTORED)
  // =========================================================

  int? selectedTileIndex;
  TileSelectionType selectionType = TileSelectionType.none;

  void selectCrop(int index) {
    selectedTileIndex = index;
    selectionType = TileSelectionType.crop;
    notifyListeners();
  }

  void selectSoil(int index) {
    selectedTileIndex = index;
    selectionType = TileSelectionType.soil;
    notifyListeners();
  }

  void clearSelections() {
    selectedTileIndex = null;
    selectionType = TileSelectionType.none;
    notifyListeners();
  }

  void plantCropAuto(CropModel crop) {
    final index = farmGrid.indexWhere((e) => e == null);
    if (index == -1) return;

    assignCropToSlot(index, crop);
  }

  // =========================================================
  // 🧠 SNAPSHOT SYSTEM
  // =========================================================

  FarmDecisionSnapshot getSnapshot(int index) {
    final cluster = farmGrid[index];
    if (cluster == null) return FarmDecisionSnapshot.empty();

    final growth = _growthEngine.evaluate(cluster);
    final irrigation = _irrigationEngine.evaluate(cluster);
    final priority = _priorityEngine.evaluate(cluster);

    return FarmDecisionSnapshot(
      cropName: cluster.crop.name,
      stage: growth.stage,
      progress: growth.progress,
      health: cluster.health,
      needsWater: irrigation.needsWater,
      waterUrgency: irrigation.urgency,
      waterMinutes: irrigation.recommendedMinutes,
      growthStage: growth.stage,
      priorityLevel: priority.level.name,
      priorityColor: _mapPriorityColor(priority.level.name),
      priorityIcon: _mapPriorityIcon(priority.level.name),
    );
  }

  // =========================================================
  // 🧹 GLOBAL RESET (SAFE)
  // =========================================================

  void clearAllState() {
    lastScan = null;
    lastDecision = null;
    activePlan = null;
    treatmentHistory.clear();
    activatedPlanIds.clear();

    showTreatmentQuickAccess = false;
    showScanResultBanner = false;
    showRecommendationHighlight = false;

    notifyListeners();
  }

  // =========================================================
  // 🎯 HISTORY SYSTEM (RESTORED)
  // =========================================================

  final List<Map<String, dynamic>> scanHistory = [];
  final List<Map<String, dynamic>> cropHistory = [];
  final List<Map<String, dynamic>> soilHistory = [];

  void addScan(Map<String, dynamic> scan) {
    scanHistory.add(scan);
    notifyListeners();
  }

  void addCrop(Map<String, dynamic> crop) {
    cropHistory.add(crop);
    notifyListeners();
  }

  void addSoil(Map<String, dynamic> soil) {
    soilHistory.add(soil);
    notifyListeners();
  }

  // =========================================================
  // 🔒 ACCESS CONTROL
  // =========================================================

  bool canAccessFarmFeatures() => isLoggedIn;

  // =========================================================
  // 🎨 PRIORITY UI HELPERS
  // =========================================================

  Color _mapPriorityColor(String level) {
    switch (level) {
      case "critical":
        return Colors.red;
      case "high":
        return Colors.orange;
      case "medium":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  IconData _mapPriorityIcon(String level) {
    switch (level) {
      case "critical":
        return Icons.warning;
      case "high":
        return Icons.error;
      case "medium":
        return Icons.water_drop;
      default:
        return Icons.eco;
    }
  }
}