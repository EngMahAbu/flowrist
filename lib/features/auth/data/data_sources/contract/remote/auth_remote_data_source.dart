import 'package:flowrist/features/auth/data/models/forget_password_response_dto.dart';
import 'package:flowrist/features/auth/data/models/reset_password_response_dto.dart';
import 'package:flowrist/features/auth/data/models/verify_otp_response_dto.dart';

abstract interface class AuthRemoteDataSource  {
  Future<ForgetPasswordResponseDto> forgotPassword({
    required String email,
  });

  Future<VerifyOtpResponseDto> verifyOtp({
    required String email,
    required String otp,
  });

  Future<ResetPasswordResponseDto> resetPassword({
    required String email,
    required String newPassword,
  });
}