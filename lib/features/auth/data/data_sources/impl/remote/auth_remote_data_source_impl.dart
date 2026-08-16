import 'package:flowrist/features/auth/data/client/auth_api_client.dart';
import 'package:flowrist/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:flowrist/features/auth/data/models/login_response.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;
  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async{
    return await _apiClient.login(request);
  }
}
