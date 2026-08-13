import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseDto> register(RegisterRequestDto request);
}