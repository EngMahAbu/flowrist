import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/auth/data/models/login_response.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi(baseUrl: Endpoints.baseUrl)
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST("api/identity/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);
}
