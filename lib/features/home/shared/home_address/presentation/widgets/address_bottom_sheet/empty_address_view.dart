import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyAddressView extends StatelessWidget {
  const EmptyAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: AppColors.purple10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off,
              color: AppColors.purpleBase,
              size: 40,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            localizations.noAddressessaved,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          Text(
            'You have no saved address yet.\n'
            'Add one to complete your gifting experience.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
