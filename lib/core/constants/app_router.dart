import 'package:flowrist/features/home/presentation/view/home_view.dart';
import 'package:flowrist/features/home/presentation/view/tabs/cart/cart_tab_view.dart';
import 'package:flowrist/features/home/presentation/view/tabs/categories/categories_tab_view.dart';
import 'package:flowrist/features/home/presentation/view/tabs/home/home_tab_view.dart';
import 'package:flowrist/features/home/presentation/view/tabs/profile/profile_tab_view.dart';
import 'package:flowrist/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const String splash = '/';

  static const String homeTab = '/home-tab';
  static const String categoriesTab = '/categories-tab';
  static const String cartTab = '/cart-tab';
  static const String profileTab = '/profile-tab';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _routes = [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
      parentNavigatorKey: _rootNavigatorKey,
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeView(tabViewShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeTab,
              builder: (context, state) => const HomeTabView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.categoriesTab,
              builder: (context, state) => const CategoriesTabView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cartTab,
              builder: (context, state) => const CartTabView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profileTab,
              builder: (context, state) => const ProfileTabView(),
            ),
          ],
        ),
      ],
    ),
  ];

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: _routes,
  );
}
