import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/app_text_field.dart';
import '../view_model/forget_password_event.dart';
import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';

class ForgetPasswordOtpView extends StatefulWidget {
  const ForgetPasswordOtpView({super.key});

  @override
  State<ForgetPasswordOtpView> createState() =>
      _ForgetPasswordOtpPageState();
}

class _ForgetPasswordOtpPageState
    extends State<ForgetPasswordOtpView> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
    AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),

          const Text(
            'Verify OTP',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          BlocBuilder<ForgetPasswordBloc,
              ForgetPasswordState>(
            builder: (context, state) {
              return Text(
                'Enter the OTP sent to '
                    '${state.email ?? 'your email'}',
                textAlign: TextAlign.center,
              );
            },
          ),

          const SizedBox(height: 40),

          AppTextField(
            label: 'OTP',
            hint: 'Enter OTP',
            controller: _otpController,
            localizations: localizations,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter OTP';
              }

              if (value.length != 6) {
                return 'OTP must contain 6 digits';
              }

              return null;
            },
          ),

          const SizedBox(height: 24),

          BlocBuilder<ForgetPasswordBloc,
              ForgetPasswordState>(
            builder: (context, state) {
              final isLoading =
                  state.status ==
                      ForgetPasswordStatus.loading &&
                      state.operation ==
                          ForgetPasswordOperation
                              .verifyOtp;

              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    if (!_formKey.currentState!
                        .validate()) {
                      return;
                    }

                    context
                        .read<ForgetPasswordBloc>()
                        .add(
                      VerifyOtpEvent(
                        _otpController.text.trim(),
                      ),
                    );
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Verify OTP'),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          BlocBuilder<ForgetPasswordBloc,
              ForgetPasswordState>(
            builder: (context, state) {
              if (state.remainingSeconds > 0) {
                return Text(
                  'Resend OTP in '
                      '${state.remainingSeconds} seconds',
                  textAlign: TextAlign.center,
                );
              }

              final isLoading =
                  state.status ==
                      ForgetPasswordStatus.loading &&
                      state.operation ==
                          ForgetPasswordOperation
                              .resendOtp;

              return TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                  context
                      .read<ForgetPasswordBloc>()
                      .add(
                    const ResendOtpEvent(),
                  );
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Resend OTP'),
              );
            },
          ),
        ],
      ),
    );
  }
}