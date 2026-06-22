import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import '../../models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  final AppState state;

  const ProfileScreen({super.key, required this.state});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();

  String experienceLevel = "Beginner";
  String farmingType = "Organic";

  bool isSaving = false;
  bool isEditMode = false;

  final levels = ["Beginner", "Moderate", "Expert"];
  final types = ["Organic", "Non-Organic", "Mixed"];

  bool get hasProfile => widget.state.profile != null;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final profile = widget.state.profile;
    if (profile != null) {
      nameController.text = profile.name;
      locationController.text = profile.location;
      experienceLevel = profile.experienceLevel ?? "Beginner";
      farmingType = profile.farmingType ?? "Organic";
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isSaving = true);

    final profile = ProfileModel(
      name: nameController.text.trim(),
      location: locationController.text.trim(),
      experienceLevel: experienceLevel,
      farmingType: farmingType,
    );

    widget.state.saveProfile(profile);

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      isSaving = false;
      isEditMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
  }

  void logout() {
    widget.state.logout();

    Navigator.popUntil(context, (route) => route.isFirst);

    widget.state.setTab(TabType.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAF3),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: hasProfile ? _buildLoggedIn() : _buildSetup(),
    );
  }

  // =========================
  // SETUP / EDIT SCREEN
  // =========================
  Widget _buildSetup() {
    final editable = !hasProfile || isEditMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "🌾 Create Your Farm Identity",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _input("Farmer Name", nameController, Icons.person, editable),
          const SizedBox(height: 12),
          _input("Location", locationController, Icons.location_on, editable),

          const SizedBox(height: 20),

          _chipGroup("Farming Type", types, farmingType, editable, (val) {
            setState(() => farmingType = val);
          }),

          const SizedBox(height: 20),

          _chipGroup("Experience", levels, experienceLevel, editable, (val) {
            setState(() => experienceLevel = val);
          }),

          const SizedBox(height: 30),

          if (editable)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(14),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Profile"),
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // LOGGED IN VIEW
  // =========================
  Widget _buildLoggedIn() {
    final p = widget.state.profile!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("👨‍🌾 ${p.name}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("📍 ${p.location}"),
                Text("🌱 Type: ${p.farmingType}"),
                Text("📊 Level: ${p.experienceLevel}"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _actionTile(
            icon: Icons.edit,
            title: "Edit",
            onTap: () {
              setState(() => isEditMode = true);
            },
          ),

          _actionTile(
            icon: Icons.history,
            title: "History",
            onTap: () {},
          ),

          _actionTile(
            icon: Icons.logout,
            title: "Logout",
            isDanger: true,
            onTap: logout,
          ),
        ],
      ),
    );
  }

  // =========================
  // HELPERS
  // =========================
  Widget _input(String label, TextEditingController c, IconData icon, bool enabled) {
    return TextField(
      controller: c,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _chipGroup(
    String title,
    List<String> items,
    String selected,
    bool enabled,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: items.map((e) {
            final isSelected = e == selected;
            return ChoiceChip(
              label: Text(e),
              selected: isSelected,
              onSelected: enabled ? (_) => onSelect(e) : null,
              selectedColor: Colors.green,
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDanger ? Colors.red : Colors.green),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: child,
    );
  }
}