import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../scan/disease_detection_screen.dart';
import '../scan/plan_screen.dart';
import '../profile/profile_screen.dart';
import '../soil/soil_screen.dart';
import '../recommendation/crop_recommendation_screen.dart';
import '../auth/login_screen.dart';
import '../farm/farm_grid_widget.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;

  const HomeScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF4),
      appBar: AppBar(
        title: const Text("AgroMind"),
        backgroundColor: Colors.green,
      ),

      bottomNavigationBar:
          state.isLoggedIn ? _buildBottomNav() : null,

      body: _buildBody(context),
    );
  }

  // =========================
  // BODY ROUTER
  // =========================
  Widget _buildBody(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        if (!state.isLoggedIn && state.tab != TabType.scan) {
          return _buildGuestUI(context);
        }
        return _buildTabView(context);
      },
    );
  }

  // =========================
  // GUEST UI
  // =========================
  Widget _buildGuestUI(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 60,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "AgroMind",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 40),

                // BUTTON 1 (RENAMED)
                ElevatedButton.icon(
                  onPressed: () => state.setTab(TabType.scan),
                  icon: const Icon(Icons.local_florist),
                  label: const Text("What happened to my crop"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 12),

                // BUTTON 2 (RENAMED)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => SoilScreen(state: state),
  ),
);
                  },
                  icon: const Icon(Icons.agriculture),
                  label: const Text("What crop to plant"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),

        // LOGIN BUTTON (BOTTOM RIGHT ONLY FOR GUEST)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.brown,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(state: state),
                ),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text("Login"),
          ),
        ),
      ],
    );
  }

  // =========================
  // TAB ROUTER
  // =========================
  Widget _buildTabView(BuildContext context) {
    switch (state.tab) {
      case TabType.home:
        return _buildHomeDashboard(context);

      case TabType.scan:
        return DiseaseDetectionScreen(state: state);

      case TabType.recommend:
  if (state.soilData == null) {
    return SoilScreen(state: state);
  }
  return CropRecommendationScreen(state: state);
  
      case TabType.profile:
        return ProfileScreen(state: state);
    }
  }

  // =========================
  // HOME DASHBOARD
  // =========================
 Widget _buildHomeDashboard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "AgroMind",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        // =========================
        // TREATMENT PREVIEW CARD
        // =========================
        if (state.activePlan != null)
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              title: Text(state.activePlan!.disease),
              subtitle: Text("Status: ${state.activePlan!.status}"),
              trailing: Text(state.activePlan!.severity),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlanScreen(
                                                state: state,
                                                plan: state.treatmentHistory.last,
                                             )
                  ),
                );
              },
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text("No treatment plan created yet"),
          ),

        const SizedBox(height: 10),

        // =========================
        // 🔥 NEW: QUICK ACCESS BUTTON (YOUR REQUIREMENT)
        // =========================
        if (state.activePlan != null &&
            state.showTreatmentQuickAccess)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                       PlanScreen(
  state: state,
  plan: state.treatmentHistory.last,
)
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(Icons.medical_services,
                          color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "View Treatment Plan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 10),

        // =========================
        // FARM GRID
        // =========================
        Expanded(
          child: Center(
            child: SizedBox(
              width: 320,
              child: FarmGridWidget(state: state),
            ),
          ),
        ),
      ],
    ),
  );
}
  // =========================
  // BOTTOM NAVIGATION
  // =========================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getTabIndex(state.tab),
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      showUnselectedLabels: true,
      onTap: (index) {
        state.setTab(_getTabFromIndex(index));
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: "Scan",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.eco),
          label: "Recommend",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }

  int _getTabIndex(TabType tab) {
    switch (tab) {
      case TabType.home:
        return 0;
      case TabType.scan:
        return 1;
      case TabType.recommend:
        return 2;
      case TabType.profile:
        return 3;
    }
  }

  TabType _getTabFromIndex(int index) {
    switch (index) {
      case 0:
        return TabType.home;
      case 1:
        return TabType.scan;
      case 2:
        return TabType.recommend;
      case 3:
        return TabType.profile;
      default:
        return TabType.home;
    }
  }
}