import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(SecureStorageService secureStorageService) {
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
            final token = await secureStorageService.get(
              AppConstants.storageTokenKey,
            );

            if (token.isNotEmpty) {
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

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true, 
        error: true,
        logPrint: (obj) => log(obj.toString()), 
      ),
    );

    return dio;
  }
}
