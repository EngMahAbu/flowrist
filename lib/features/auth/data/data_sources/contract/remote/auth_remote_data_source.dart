import 'package:flowrist/features/auth/data/models/forgetPassword_response_dto.dart';
import 'package:flowrist/features/auth/data/models/resetPassword_response_dto.dart';
import 'package:flowrist/features/auth/data/models/verifyOtp_response_dto.dart';

abstract  class AuthRemoteDataSource  {
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