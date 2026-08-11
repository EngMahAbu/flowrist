import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowrist/config/dio/token_service.dart';
import 'package:flowrist/config/storage/secure_storage.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  SecureStorage secureStorageService(FlutterSecureStorage storage) {
    return SecureStorageService(storage);
  }

  @lazySingleton
  TokenService tokenService(SecureStorage secureStorage) {
    return TokenService(secureStorage);
  }

  @lazySingleton
  Dio dio(TokenService tokenService) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await tokenService.getToken();

            if (token != null && token.isNotEmpty) {
              options.headers['token'] = token;
            }
          } catch (error, stackTrace) {
            log(
              'Failed to retrieve authentication token',
              error: error,
              stackTrace: stackTrace,
            );
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
