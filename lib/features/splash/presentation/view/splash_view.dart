import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
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
  @override
  void initState() {
    super.initState();

    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    final sessionService = getIt<SessionService>();

    try {
      final rememberMe = await sessionService.isRemembered();
      final isGuest = await sessionService.isGuest();

      if (!mounted) return;

      if (rememberMe || isGuest) {
        context.go(AppRoutes.homeTab);
      } else {
        context.go(AppRoutes.occasions);
      }
    } catch (e) {
      if (!mounted) return;

      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsGeometry.directional(
            start: AppDimensions.defaultScreenPadding,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        title: Text('Gallery Screen'),
      ),
      body: GalleryView(),
    );
  }
}
