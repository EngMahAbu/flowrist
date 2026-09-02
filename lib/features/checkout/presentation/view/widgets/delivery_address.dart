import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/delivery_address_item.dart';
import 'package:flutter/material.dart';

class DeliveryAddress extends StatelessWidget {
  const DeliveryAddress({super.key});

  @override
  Widget build(BuildContext context) {
      final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.deliveryAddress,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return const DeliveryAddressItem();
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(side: BorderSide()),
              icon: Icon(Icons.add, size: 24, color: AppColors.purpleBase),
              label: Text(
                localizations.addNew,
                style: TextStyle(
                  color: AppColors.purpleBase,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
