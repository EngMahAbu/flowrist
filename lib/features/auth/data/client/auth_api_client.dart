import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/auth/data/models/forget_password_request_dto.dart';
import 'package:flowrist/features/auth/data/models/forget_password_response_dto.dart';
import 'package:flowrist/features/auth/data/models/reset_password_request_dto.dart';
import 'package:flowrist/features/auth/data/models/reset_password_response_dto.dart';
import 'package:flowrist/features/auth/data/models/verify_otp_request_dto.dart';
import 'package:flowrist/features/auth/data/models/verify_otp_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.forgetPassword)
  Future<ForgetPasswordResponseDto> forgotPassword(
      @Body() ForgetPasswordRequestDto request,
      );

  @POST(Endpoints.verifyOTP)
  Future<VerifyOtpResponseDto> verifyOtp(
      @Body() VerifyOtpRequestDto request,
      );

  @POST(Endpoints.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(
      @Body() ResetPasswordRequestDto request,
      );
}