import 'package:equatable/equatable.dart';

enum ForgetPasswordStep {
  email,
  otp,
  resetPassword,
}

enum ForgetPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

enum ForgetPasswordOperation {
  none,
  checkEmail,
  resendOtp,
  verifyOtp,
  resetPassword,
}

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStep step;
  final ForgetPasswordStatus status;
  final ForgetPasswordOperation operation;

  final String? email;
  final String? errorMessage;

  final int remainingSeconds;

  const ForgetPasswordState({
    this.step = ForgetPasswordStep.email,
    this.status = ForgetPasswordStatus.initial,
    this.operation = ForgetPasswordOperation.none,
    this.email,
    this.errorMessage,
    this.remainingSeconds = 30,
  });

  bool get isLoading =>
      status == ForgetPasswordStatus.loading;

  bool get canResend =>
      remainingSeconds == 0 &&
          operation != ForgetPasswordOperation.resendOtp;

  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    ForgetPasswordStatus? status,
    ForgetPasswordOperation? operation,
    String? email,
    String? errorMessage,
    int? remainingSeconds,
  }) {
    return ForgetPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      operation: operation ?? this.operation,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      remainingSeconds:
      remainingSeconds ?? this.remainingSeconds,
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    operation,
    email,
    errorMessage,
    remainingSeconds,
  ];
}