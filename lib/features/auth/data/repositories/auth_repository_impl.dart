import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:flowrist/features/auth/data/mapper/auth_mapper.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<UserEntity>> register(RegisterRequestDto request) async {
    try {
      final responseDto = await _remoteDataSource.register(request);
      final entity = AuthMapper.toUserEntity(responseDto);
      return SuccessResponse<UserEntity>(entity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<UserEntity>(e);
    }
  }
}
