import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/features/home/shared/home_address/presentation/cubit/home_address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationView extends StatefulWidget {
  final StatefulNavigationShell tabViewShell;

  const HomeNavigationView({super.key, required this.tabViewShell});

  @override
  State<HomeNavigationView> createState() => _HomeNavigationViewState();
}

class _HomeNavigationViewState extends State<HomeNavigationView> {
    @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAddress();
    });
  }

  Future<void> _initializeAddress() async {
    final addressCubit =
        context.read<AddressCubit>();

    await addressCubit.initializeAddress();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: widget.tabViewShell,
      bottomNavigationBar: _buildBottomNavigationBar(
          context: context, localization: l10n
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar({
    required BuildContext context,
    required AppLocalizations localization,
  }) {
    return BottomNavigationBar(
      currentIndex: widget.tabViewShell.currentIndex,
      onTap: (index) async {
        if (index == 3 || index == 2) {
          final canContinue = await checkGuestMode(context);

          if (!canContinue) {
            return;
          }
        }

        widget.tabViewShell.goBranch(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: localization.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: localization.categories,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: localization.cart,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_outlined),
          label: localization.profile,
        ),
      ],
    );
  }
}
