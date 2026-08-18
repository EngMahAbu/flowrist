import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/constants/flowery_icons.dart';
import 'package:flutter/material.dart';

class DeliveryLocationHeader extends StatelessWidget {
  const DeliveryLocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(FloweryIcons.location, size: 20),
        SizedBox(width: 2),
        Text(
          'Deliver to 2XVP+XC - Sheikh Zayed ',
          style: AppStyles.medium18Inter.copyWith(fontSize: 14),
        ),

        Transform.rotate(
          angle: 3.14 / 2,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColors.purpleBase,
            ),
          ),
        ),
      ],
    );
  }
}
