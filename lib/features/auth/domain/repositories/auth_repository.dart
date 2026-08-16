import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';

abstract interface class AuthRepository {
  Future<BaseResponse<LoginEntity>> login(LoginParams params,bool rememberMe);
}
