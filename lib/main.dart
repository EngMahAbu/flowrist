import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/core/ui/theme/app_theme.dart';
import 'package:flowrist/flowrist_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/l10n/app_localizations.dart';

void main() {
  Bloc.observer = FlowristBlocObserver();
  runApp(const FlowristApp());
}

class FlowristApp extends StatelessWidget {
  const FlowristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
