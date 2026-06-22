import 'package:flutter/material.dart';
import 'app_router.dart';
import 'app_state.dart';

class AgroMindApp extends StatefulWidget {
  const AgroMindApp({super.key});

  @override
  State<AgroMindApp> createState() => _AgroMindAppState();
}

class _AgroMindAppState extends State<AgroMindApp> {
  final AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AgroMind',
          home: AppRouter(state: state),
        );
      },
    );
  }
}