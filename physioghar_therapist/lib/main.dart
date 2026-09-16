import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/theme.dart';

import 'features/navigation/main_navigation_screen.dart';

void main() {
  runApp(const ProviderScope(child: PhysioGharApp()));
}

class PhysioGharApp extends StatelessWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhysioGhar Therapist',
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}
