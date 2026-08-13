import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/auth/data/models/forgetPassword_request_dto.dart';
import 'package:flowrist/features/auth/data/models/forgetPassword_response_dto.dart';
import 'package:flowrist/features/auth/data/models/resetPassword_request_dto.dart';
import 'package:flowrist/features/auth/data/models/resetPassword_response_dto.dart';
import 'package:flowrist/features/auth/data/models/verifyOtp_request_dto.dart';
import 'package:flowrist/features/auth/data/models/verifyOtp_response_dto.dart';
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