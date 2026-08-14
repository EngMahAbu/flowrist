import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/auth/presentation/signup/utils/signup_form_validator.dart';
import 'package:flutter/material.dart';

class PasswordFields extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AppLocalizations localizations;
  final double screenWidth;

  const PasswordFields({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.localizations,
    required this.screenWidth,
  });

  @override
  State<PasswordFields> createState() => PasswordFieldsState();
}

class PasswordFieldsState extends State<PasswordFields> {
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPasswordField()),
        SizedBox(width: widget.screenWidth * 0.03),
        Expanded(child: _buildConfirmPasswordField()),
      ],
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      label: widget.localizations.password,
      hint: widget.localizations.enterPassword,
      obscureText: _isPasswordObscure,
      controller: widget.passwordController,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordObscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.grey10,
        ),
        onPressed: () =>
            setState(() => _isPasswordObscure = !_isPasswordObscure),
      ),
      validator: (value) => SignUpFormValidator.validatePassword(
        value: value,
        localizations: widget.localizations,
      ),
      localizations: widget.localizations,
    );
  }

  Widget _buildConfirmPasswordField() {
    return AppTextField(
      label: widget.localizations.confirmPassword,
      hint: widget.localizations.confirmPassword,
      obscureText: _isConfirmPasswordObscure,
      controller: widget.confirmPasswordController,
      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordObscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.grey10,
        ),
        onPressed: () => setState(
          () => _isConfirmPasswordObscure = !_isConfirmPasswordObscure,
        ),
      ),
      validator: (value) => SignUpFormValidator.validateConfirmPassword(
        value: value,
        password: widget.passwordController.text,
        localizations: widget.localizations,
      ),
      localizations: widget.localizations,
    );
  }
}
