import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:flowrist/features/auth/data/models/login_response.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseDto> register(RegisterRequestDto request);
  Future<LoginResponse> login(LoginRequest request); 
}