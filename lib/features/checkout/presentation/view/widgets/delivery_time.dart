import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveryTime extends StatelessWidget {
  const DeliveryTime({super.key});

  @override
  Widget build(BuildContext context) {
      final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.deliveryTime,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time),
              Text(
                 localizations.instantArriveBy,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                "03 Sep 2024, 11:00 AM ",
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
