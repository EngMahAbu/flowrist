import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.register)
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);
}
