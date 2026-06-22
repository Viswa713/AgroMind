import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/treatment_plan_model.dart';
import '../home/home_screen.dart';


class PlanScreen extends StatelessWidget {
  final AppState state;
  final TreatmentPlan plan;
  
  const PlanScreen({
  super.key,
  required this.state,
  required this.plan,
});

  @override
  Widget build(BuildContext context) {
    final plan = state.activePlan;

    if (plan == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Treatment Plan"),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text(
            "No active treatment plan.\nCreate one from disease scan.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Recovery Plan: ${plan.disease}"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(plan),
          const SizedBox(height: 16),

          _buildSectionTitle("📊 Status Overview"),
          _buildStatusCard(plan),

          const SizedBox(height: 16),

          _buildSectionTitle("🧾 Diagnosis"),
          _buildDiagnosisCard(plan),

          const SizedBox(height: 16),

          _buildSectionTitle("💊 Treatment Actions"),
          _buildStepsCard(plan.steps),

          const SizedBox(height: 16),

          _buildSectionTitle("⏳ Expected Timeline"),
          _buildTimelineCard(),

          const SizedBox(height: 16),

          _buildSectionTitle("📅 Monitoring Schedule"),
          _buildMonitoringCard(),

          const SizedBox(height: 16),

          _buildActionButton(context),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(TreatmentPlan plan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Active Treatment Plan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            plan.disease,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text("Created: ${plan.createdAt.toString().split('.')[0]}"),
        ],
      ),
    );
  }

  // ================= STATUS =================
  Widget _buildStatusCard(TreatmentPlan plan) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: ${plan.status}"),
          const SizedBox(height: 6),
          Text("Progress: ${plan.progress}%"),
          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: plan.progress / 100,
            color: Colors.green,
            backgroundColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  // ================= DIAGNOSIS =================
  Widget _buildDiagnosisCard(TreatmentPlan plan) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This crop is infected and requires immediate action."),
          SizedBox(height: 8),
          Text("System has classified it as a manageable condition."),
        ],
      ),
    );
  }

  // ================= STEPS =================
  Widget _buildStepsCard(List<String> steps) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${i + 1}. ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(step)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================= TIMELINE =================
  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Day 1–2: Infection control begins"),
          Text("Day 3–5: Symptoms stabilize"),
          Text("Day 6–10: Visible recovery"),
          Text("Day 10+: Full recovery expected"),
        ],
      ),
    );
  }

  // ================= MONITORING =================
  Widget _buildMonitoringCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended Re-scans:"),
          SizedBox(height: 8),
          Text("• Day 2 → Check infection spread"),
          Text("• Day 5 → Evaluate improvement"),
          Text("• Day 10 → Final assessment"),
        ],
      ),
    );
  }

  // ================= BUTTON =================
 Widget _buildActionButton(BuildContext context) {
  final isActivated = state.isPlanActivated(plan.id);

  if (isActivated) {
    return const SizedBox();
  }

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      padding: const EdgeInsets.all(14),
    ),
    onPressed: () {
      // 1. activate plan
      state.activatePlan(plan.id);

      // 2. switch tab to HOME (IMPORTANT FIX)
      state.setTab(TabType.home);

      // 3. close plan screen (back to Home container)
      Navigator.pop(context);
    },
    child: const Text("Mark as Understood"),
  );
}
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}