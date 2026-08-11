// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../dio/dio_module.dart' as _i977;
import '../dio/token_service.dart' as _i947;
import '../storage/secure_storage.dart' as _i619;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => dioModule.secureStorage);
    gh.lazySingleton<_i619.SecureStorage>(
      () => dioModule.secureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i947.TokenService>(
      () => dioModule.tokenService(gh<_i619.SecureStorage>()),
    );
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio(gh<_i947.TokenService>()));
    return this;
  }
}

class _$DioModule extends _i977.DioModule {}
