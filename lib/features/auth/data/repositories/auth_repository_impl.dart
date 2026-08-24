import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:flowrist/features/auth/data/mapper/auth_mapper.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/network/safe_call/safe_call.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorageService);

  @override
  Future<BaseResponse<UserEntity>> register(RegisterRequestDto request) async {
    return safeCall<UserEntity>(() async {
      final responseDto = await _remoteDataSource.register(request);
      return SuccessResponse<UserEntity>(AuthMapper.toUserEntity(responseDto));
    });
  }

  @override
  Future<BaseResponse<LoginEntity>> login(
    LoginParams params,
    bool rememberMe,
  ) async {
    try {
      final request = LoginRequest(
        email: params.email,
        password: params.password,
        fcmToken: params.fcmToken,
      );
      final response = await _remoteDataSource.login(request);
      final loginEntity = response.toEntity();
      await _secureStorageService.save(
        AppConstants.rememberMeKey,
        rememberMe.toString(),
      );

      await _secureStorageService.save(AppConstants.guestModeKey, 'false');

      if (rememberMe) {
        await _secureStorageService.save(
          AppConstants.storageTokenKey,
          loginEntity.token,
        );
      } else {
        await _secureStorageService.delete(AppConstants.storageTokenKey);
      }
      return SuccessResponse(loginEntity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<LoginEntity>(e);
    }
  }

  @override
  Future<BaseResponse<void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);

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

  @override
  Future<BaseResponse<void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(email: email, otp: otp);

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }
}
