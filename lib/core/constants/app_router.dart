import 'package:flowrist/features/auth/presentation/login/view/login_view.dart';
import 'package:flowrist/features/auth/presentation/signup/view/signup_view.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/view/cart_tab_view.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/view/categories_tab_view.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_cubit.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/view/best_seller_view.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occasion_cubit.dart';
import 'package:flowrist/features/home/home/presentation/occasion/view/occasion_view.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/home_tab_view.dart';
import 'package:flowrist/features/home/profile/presentation/view/profile_tab_view.dart';
import 'package:flowrist/features/home/shared/home_navigation_view.dart';
import 'package:flowrist/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const String splash = '/';

  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String homeTab = '/home-tab';
  static const String categoriesTab = '/categories-tab';
  static const String cartTab = '/cart-tab';
  static const String profileTab = '/profile-tab';
  static const String bestSeller = '/best-seller';
  static const String occasions = '/occasions';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _routes = [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
      parentNavigatorKey: _rootNavigatorKey,
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpView(),
      parentNavigatorKey: _rootNavigatorKey,
    ),
    GoRoute(
      path: AppRoutes.bestSeller,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<BestSellerCubit>(),
          child: const BestSellerView(),
        );
      },
      parentNavigatorKey: _rootNavigatorKey,
    ),
    GoRoute(
      path: AppRoutes.occasions,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<OccasionCubit>(),
          child: const OccasionView(),
        );
      },
      parentNavigatorKey: _rootNavigatorKey,
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginView(),
        );
      },
      parentNavigatorKey: _rootNavigatorKey,
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeNavigationView(tabViewShell: navigationShell);
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
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<CategoriesCubit>(),
                child: const CategoriesTabView(),
              ),
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
