import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/app_text_field.dart';
import '../view_model/forget_password_event.dart';
import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),

          const Text(
            'Create New Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          AppTextField(
            label: 'New Password',
            hint: 'Enter new password',
            controller: _passwordController,
            localizations: localizations,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }

              final result = FormValidator.validatePassword(value);

              return switch (result) {
                Valid() => null,
                LengthError() =>
                'Password must be at least 8 characters',
                UppercaseError() =>
                'Password must contain an uppercase letter',
                LowercaseError() =>
                'Password must contain a lowercase letter',
                NumberError() =>
                'Password must contain a number',
                SpecialCharError() =>
                'Password must contain a special character',
              };
            },
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),

          const SizedBox(height: 20),

          AppTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: _confirmPasswordController,
            localizations: localizations,
            obscureText: _obscureConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }

              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }

              return null;
            },
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword =
                  !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),

          const SizedBox(height: 24),

          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              final isLoading =
                  state.status == ForgetPasswordStatus.loading &&
                      state.operation ==
                          ForgetPasswordOperation.resetPassword;

              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    context.read<ForgetPasswordBloc>().add(
                      ResetPasswordEvent(
                        _passwordController.text,
                      ),
                    );
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Reset Password'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}