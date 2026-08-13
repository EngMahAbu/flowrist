import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<BaseResponse<UserEntity>> register(RegisterRequestDto request);
}
