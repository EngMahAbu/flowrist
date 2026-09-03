import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/gift_text_field.dart';
import 'package:flutter/material.dart';

class GiftMethods extends StatefulWidget {
  const GiftMethods({
    super.key,
    required this.onChanged,
  });

  final void Function({
    required bool isGift,
    required String name,
    required String phone,
  }) onChanged;

  @override
  State<GiftMethods> createState() => _GiftMethodsState();
}

class _GiftMethodsState extends State<GiftMethods> {
  bool _isGift = false;

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(
      isGift: _isGift,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Switch(
                inactiveTrackColor: AppColors.purple20,
                activeTrackColor: AppColors.purpleBase,
                thumbColor: const WidgetStatePropertyAll(
                  AppColors.white,
                ),
                value: _isGift,
                onChanged: (value) {
                  setState(() {
                    _isGift = value;
                  });

                  _notifyChanged();
                },
              ),
              const SizedBox(width: 8),
              Text(
                localizations.itIsAGift,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          if (_isGift) ...[
            const SizedBox(height: 16),

            GiftTextField(
              controller: _nameController,
              hint: localizations.enterTheName,
              label: localizations.name,
              onChanged: (_) => _notifyChanged(),
            ),

            const SizedBox(height: 16),

            GiftTextField(
              controller: _phoneController,
              hint: localizations.enterThePhoneNumber,
              label: localizations.phoneNumber,
              onChanged: (_) => _notifyChanged(),
            ),
          ],
        ],
      ),
    );
  }
}