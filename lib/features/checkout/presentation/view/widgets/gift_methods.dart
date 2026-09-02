import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/gift_text_field.dart';
import 'package:flutter/material.dart';

class GiftMethods extends StatelessWidget {
  const GiftMethods({super.key});

  @override
  Widget build(BuildContext context) {
      final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Switch(
                inactiveTrackColor: AppColors.purple20,
                activeTrackColor: AppColors.purpleBase,
                thumbColor: WidgetStatePropertyAll(AppColors.white),
                value: true,
                onChanged: (value) {
                  value = value;
                },
              ),
              SizedBox(width: 8),
              Text(
                localizations.itIsAGift,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 16),
           GiftTextField(
            hint: localizations.enterTheName,
            label: localizations.name
           ),
             SizedBox(height: 16),
           GiftTextField(
            hint: localizations.enterThePhoneNumber,
            label: localizations.phoneNumber
           ),

        
         
        ],
      ),
    );
  }
}
