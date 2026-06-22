import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import 'app_state.dart';

class AppRouter extends StatelessWidget {
  final AppState state;

  const AppRouter({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return HomeScreen(state: state);
  }
}