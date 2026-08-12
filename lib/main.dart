import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/l10n/app_localizations.dart';

void main() {
  runApp(const FlowristApp());
}

class FlowristApp extends StatelessWidget {
  const FlowristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const SplashView(),
    );
  }
}
