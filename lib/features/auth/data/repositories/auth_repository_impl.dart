import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/api_error_handler/api_error_handler.dart';
import '../data_sources/contract/remote/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _remoteDataSource.forgotPassword(
        email: email,
      );

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }

  @override
  Future<BaseResponse<void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
      );

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
      );

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }
}