import 'package:equatable/equatable.dart';

import '../../../../../config/base_state/base_state.dart';

enum ForgetPasswordStep {
  email,
  otp,
  resetPassword,
}

enum ForgetPasswordOperation {
  none,
  checkEmail,
  resendOtp,
  verifyOtp,
  resetPassword,
}

class ForgetPasswordState
    extends BaseState<dynamic>
    with EquatableMixin {
  final ForgetPasswordStep step;
  final ForgetPasswordOperation operation;
  final String otp;
  final String? email;
  final int remainingSeconds;

  ForgetPasswordState({
    this.step = ForgetPasswordStep.email,
    this.operation = ForgetPasswordOperation.none,
    this.otp = '',
    this.email,
    this.remainingSeconds = 30,
    bool isLoading = false,
    String? errorMessage,
    dynamic data,
  }) : super(
    isLoading: isLoading,
    errorMessage: errorMessage,
    data: data,
  );

  bool get canResend =>
      remainingSeconds == 0 &&
          operation != ForgetPasswordOperation.resendOtp;

  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    ForgetPasswordOperation? operation,
    String? otp,
    String? email,
    int? remainingSeconds,
    bool? isLoading,
    String? errorMessage,
    dynamic data,
  }) {
    return ForgetPasswordState(
      step: step ?? this.step,
      operation: operation ?? this.operation,
      otp: otp ?? this.otp,
      email: email ?? this.email,
      remainingSeconds:
      remainingSeconds ?? this.remainingSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
    step,
    operation,
    otp,
    email,
    remainingSeconds,
    isLoading,
    errorMessage,
    data,
  ];
}