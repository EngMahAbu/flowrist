import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/app_text_field.dart';
import '../view_model/forget_password_event.dart';
import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';
import 'otp_text_field.dart';

class ForgetPasswordOtpView extends StatelessWidget {
  const ForgetPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Form(
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

          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              return Text(
                'Enter the OTP sent to '
                    '${state.email ?? 'your email'}',
                textAlign: TextAlign.center,
              );
            },
          ),

          const SizedBox(height: 40),

          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              return OtpInputField(
                initialValue: state.otp,
                onChanged: (value) {
                  context.read<ForgetPasswordBloc>().add(
                    OtpChangedEvent(value),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),

          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              final isLoading =
                  state.status == ForgetPasswordStatus.loading &&
                      state.operation ==
                          ForgetPasswordOperation.verifyOtp;

              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    final form = Form.of(context);

                    if (!form.validate()) {
                      return;
                    }

                    context.read<ForgetPasswordBloc>().add(
                      VerifyOtpEvent(
                        state.otp.trim(),
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
                      : const Text('Verify OTP'),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              if (state.remainingSeconds > 0) {
                return Text(
                  'Resend OTP in '
                      '${state.remainingSeconds} seconds',
                  textAlign: TextAlign.center,
                );
              }

              final isLoading =
                  state.status == ForgetPasswordStatus.loading &&
                      state.operation ==
                          ForgetPasswordOperation.resendOtp;

              return TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                  context.read<ForgetPasswordBloc>().add(
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