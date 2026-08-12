import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlowristApp());
}

class FlowristApp extends StatelessWidget {
  const FlowristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const SplashView(),
    );
  }
}
