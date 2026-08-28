import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const Duration _splashDuration =
      Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    _startSplash();
  }

  Future<void> _startSplash() async {
    // =========================================================
    // 1. SHOW SPLASH
    // =========================================================

    await Future.delayed(_splashDuration);

    if (!mounted) return;

    // =========================================================
    // 2. REMOVE SPLASH FIRST
    // =========================================================

    final sessionService = getIt<SessionService>();

    final isRemembered =
        await sessionService.isRemembered();

    if (!mounted) return;

    // =========================================================
    // 3. GO TO NEXT SCREEN
    // =========================================================

    if (isRemembered) {
      context.go(AppRoutes.homeTab);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GalleryView(),
    );
  }
}