import 'package:flowrist/features/auth/data/client/auth_api_client.dart';
import 'package:flowrist/features/auth/data/models/forgetPassword_request_dto.dart';
import 'package:flowrist/features/auth/data/models/forgetPassword_response_dto.dart';
import 'package:flowrist/features/auth/data/models/resetPassword_request_dto.dart';
import 'package:flowrist/features/auth/data/models/resetPassword_response_dto.dart';
import 'package:flowrist/features/auth/data/models/verifyOtp_request_dto.dart';
import 'package:flowrist/features/auth/data/models/verifyOtp_response_dto.dart';
import 'package:injectable/injectable.dart';

import '../../contract/remote/auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ForgetPasswordResponseDto> forgotPassword({
    required String email,
  }) {
    final request = ForgetPasswordRequestDto(
      email: email,
    );

    return _apiClient.forgotPassword(request);
  }

  @override
  Future<VerifyOtpResponseDto> verifyOtp({
    required String email,
    required String otp,
  }) {
    final request = VerifyOtpRequestDto(
      email: email,
      otp: otp,
    );

    return _apiClient.verifyOtp(request);
  }

  @override
  Future<ResetPasswordResponseDto> resetPassword({
    required String email,
    required String newPassword,
  }) {
    final request = ResetPasswordRequestDto(
      email: email,
      newPassword: newPassword,
    );

    return _apiClient.resetPassword(request);
  }
}