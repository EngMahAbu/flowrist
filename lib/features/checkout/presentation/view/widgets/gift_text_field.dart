import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class GiftTextField extends StatelessWidget {
  const GiftTextField({super.key, required this.hint, required this.label});
  final String hint;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white70,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey),
        ),
      ),
    );
  }
}
